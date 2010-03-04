Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0CDMLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 07:11:03 -0500
Received: from daytona.panasas.com ([67.152.220.89]:61853 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755785Ab0CDMLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 07:11:00 -0500
Message-ID: <4B8FA351.9030000@panasas.com>
Date: Thu, 04 Mar 2010 14:10:57 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Subject: [GIT PULL] exofs changes for 2.6.34
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2010 12:10:58.0896 (UTC) FILETIME=[BFFAED00:01CABB93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus please pull the following changes since commit:

  Linux 2.6.33-rc6

They are available in the git repository at:

  git://git.open-osd.org/linux-open-osd.git for-linus

Boaz Harrosh (11):
      exofs: debug print even less
      exofs: Micro-optimize exofs_i_info
      exofs: Recover in the case of read-passed-end-of-file
      exofs: Move layout related members to a layout structure
      exofs: unindent exofs_sbi_read
      exofs: Define on-disk per-inode optional layout attribute
      exofs: RAID0 support
      exofs: convert io_state to use pages array instead of bio at input
      exofs: Error recovery if object is missing from storage
      exofs: Prepare for groups
      exofs: groups support

 fs/exofs/common.h |   39 ++++
 fs/exofs/exofs.h  |   53 ++++-
 fs/exofs/inode.c  |  194 +++++++++++-------
 fs/exofs/ios.c    |  575 +++++++++++++++++++++++++++++++++++++++++++++--------
 fs/exofs/super.c  |  121 +++++++++---
 5 files changed, 779 insertions(+), 203 deletions(-)

What's new:
  The main changes are support for data striping and *striping-groups*.
striping-groups is a nice option when there are lots of devices in the
system, but the striping of each file is confined to fewer devices, so
not to keep all devices busy on each IO. For example a 10 out of 100
striping means each file is striped across 10 devices out of 100 total
devices in the full system.
  Note that exofs has a unique layout structure that enables Mirrors
orthogonal to any striping/raid arrangement.

 Next changes will be support for raid5 and raid6

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
