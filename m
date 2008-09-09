Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYIIFqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYIIFqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 01:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYIIFqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 01:46:16 -0400
Received: from smtp.nokia.com ([192.100.122.233]:42226 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYIIFqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:46:14 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Tue, 09 Sep 2008 10:22:27 +0300
Message-Id: <20080909072227.22097.92318.sendpatchset@gollum>
Subject: [GIT PULL] [Resend] UBIFS updates for 2.6.27-rc6
X-OriginalArrivalTime: 09 Sep 2008 05:44:30.0190 (UTC) FILETIME=[20F470E0:01C9123F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

git://git.infradead.org/~dedekind/ubifs-2.6.git linux-next

The following changes since commit 6a55617ed5d1aa62b850de2cf66f5ede2eef4825:
  Linus Torvalds (1):
        Linux v2.6.27-rc4

are available:

Adrian Hunter (2):
      UBIFS: always read hashed-key nodes under TNC mutex
      UBIFS: allow for racing between GC and TNC

Artem Bityutskiy (13):
      UBIFS: fix zero-length truncations
      UBIFS: do not update min_idx_lebs in stafs
      UBIFS: push empty flash hack down
      UBIFS: remove incorrect index space check
      UBIFS: improve statfs reporting
      UBIFS: fix assertion
      UBIFS: add forgotten gc_idx_lebs component
      UBIFS: introduce LEB overhead
      UBIFS: improve statfs reporting even more
      UBIFS: fill f_fsid
      UBIFS: amend f_fsid
      UBIFS: fix division by zero
      UBIFS: make minimum fanout 3

 fs/ubifs/budget.c      |  114 ++++++++++++++++++++++++++++++++++++-----------
 fs/ubifs/dir.c         |    1 -
 fs/ubifs/file.c        |   20 +++++++--
 fs/ubifs/find.c        |   18 +++----
 fs/ubifs/gc.c          |    6 +++
 fs/ubifs/misc.h        |   49 +++++++-------------
 fs/ubifs/super.c       |   22 ++++++---
 fs/ubifs/tnc.c         |  116 +++++++++++++++++++++++++-----------------------
 fs/ubifs/ubifs-media.h |    2 +-
 fs/ubifs/ubifs.h       |   14 +++++-
 10 files changed, 221 insertions(+), 141 deletions(-)


Few notes. We included only the stuff we consider to be fixes and
improvement/new feature patches were not included. These patches:

UBIFS: do not update min_idx_lebs in stafs
UBIFS: push empty flash hack down
UBIFS: improve statfs reporting
UBIFS: introduce LEB overhead
UBIFS: improve statfs reporting even more

which may look like non-fixes actually fix this complaint:
http://lists.infradead.org/pipermail/linux-mtd/2008-August/022579.html

The
UBIFS: fill f_fsid
UBIFS: amend f_fsid

patches we also consider as fixes because it's not really OK
to avoid filling f_fsid, and we need f_fsid for NFS support.

Thanks.
