Return-Path: <linux-kernel-owner+w=401wt.eu-S1751702Ab0AAOEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0AAOEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 09:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612Ab0AAOEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 09:04:51 -0500
Received: from uiae.at ([83.151.28.67]:60338 "EHLO uiae.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab0AAOEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 09:04:50 -0500
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jan 2010 09:04:50 EST
Date: Fri, 1 Jan 2010 14:56:06 +0100
From: Michael Schutte <michi@uiae.at>
To: linux-kernel@vger.kernel.org
Cc: Samuel Thibault <samuel.thibault@labri.fr>
Subject: [PATCH] fs/compat_ioctl.c: Add KD[GS]KBDIACRUC to the compatible list
Message-ID: <20100101135606.GA3189@graeme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Jabber-ID: michi@uiae.at
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow handling of Unicode compose sequences by 32-bit apps on a 64-bit
system.  The issue has been reported in <http://bugs.debian.org/540534>
and <http://lists.altlinux.org/pipermail/kbd/2009-December/000235.html>.

A formal check of the two affected ioctls in drivers/char/vt_ioctl.c
(introduced in 04c71976) and a test using x86 kbd 1.15.1 on a so patched
x86_64 kernel both confirm that KD[GS]KBDIACRUC are ioctl32()
compatible.

Signed-off-by: Michael Schutte <michi@uiae.at>
---
 fs/compat_ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 332dd00..07096e9 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -991,6 +991,8 @@ COMPATIBLE_IOCTL(KDGKBSENT)
 COMPATIBLE_IOCTL(KDSKBSENT)
 COMPATIBLE_IOCTL(KDGKBDIACR)
 COMPATIBLE_IOCTL(KDSKBDIACR)
+COMPATIBLE_IOCTL(KDGKBDIACRUC)
+COMPATIBLE_IOCTL(KDSKBDIACRUC)
 COMPATIBLE_IOCTL(KDKBDREP)
 COMPATIBLE_IOCTL(KDGKBLED)
 COMPATIBLE_IOCTL(KDGETLED)
-- 
1.6.5


-- 
Michael Schutte <michi@uiae.at>
