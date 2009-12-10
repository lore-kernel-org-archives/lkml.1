Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZLJIcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZLJIcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZLJIcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:32:47 -0500
Received: from daytona.panasas.com ([67.152.220.89]:45072 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751823AbZLJIcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:32:46 -0500
Message-ID: <4B20B237.80601@panasas.com>
Date: Thu, 10 Dec 2009 10:32:55 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [GIT PULL] exofs updates for v2.6.33
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2009 08:32:52.0810 (UTC) FILETIME=[5D5DAAA0:01CA7973]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Hi

Now that all SCSI pre-requisites are merged
please pull:
  git://git.open-osd.org/linux-open-osd.git for-linus

The main advancement in the exofs code is support for multiple devices.
Currently only mirror operations are supported. Next Kernels, also striping
and RAID, over mirrors, will be added as well. With same disk format and
device tables. (Currently it refuses to mount configurations not supported
by the IO engine)

These are the changes since commit 3067e02f8f3ae2f3f02ba76400d03b8bcb4942b0:
  Linus Torvalds (1):
        Merge branch 'acpica' of git://git.kernel.org/.../lenb/linux-acpi-2.6

Boaz Harrosh (8):
      exofs: More sane debug print
      exofs: dbg-print less
      exofs: refactor exofs_i_info initialization into common helper
      exofs: Prints on mount and unmout
      exofs: statfs blocks is sectors not FS blocks
      exofs: move osd.c to ios.c
      exofs: Move all operations to an io_engine
      exofs: Multi-device mirror support

Thadeu Lima de Souza Cascardo (1):
      trivial: some small fixes in exofs documentation

 Documentation/filesystems/00-INDEX  |    2 +
 Documentation/filesystems/exofs.txt |   23 +-
 fs/exofs/Kbuild                     |    2 +-
 fs/exofs/common.h                   |   81 +++++--
 fs/exofs/exofs.h                    |   97 ++++++++-
 fs/exofs/inode.c                    |  409 +++++++++++++++++-----------------
 fs/exofs/ios.c                      |  421 +++++++++++++++++++++++++++++++++++
 fs/exofs/osd.c                      |  125 -----------
 fs/exofs/pnfs.h                     |   51 +++++
 fs/exofs/super.c                    |  353 ++++++++++++++++++++++-------
 10 files changed, 1107 insertions(+), 457 deletions(-)
 create mode 100644 fs/exofs/ios.c
 delete mode 100644 fs/exofs/osd.c
 create mode 100644 fs/exofs/pnfs.h

Thanks
Boaz
