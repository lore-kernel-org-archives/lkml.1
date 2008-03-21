Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbYCUWrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbYCUWrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762466AbYCUWpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:45:54 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34683 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762364AbYCUWpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:45:53 -0400
Message-Id: <20080321224403.566242615@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <12o3l@tiscali.nl>, Evgeniy Dushistov <dushistov@mail.ru>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 36/76] ufs: fix parenthesisation in ufs_set_fs_state()
Content-Disposition: inline; filename=ufs-fix-parenthesisation-in-ufs_set_fs_state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Roel Kluin <12o3l@tiscali.nl>

This bug snuck in with

commit 252e211e90ce56bf005cb533ad5a297c18c19407
Author: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Date:   Tue Oct 16 23:26:31 2007 -0700

    Add in SunOS 4.1.x compatible mode for UFS

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ufs/util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -58,7 +58,7 @@ ufs_set_fs_state(struct super_block *sb,
 {
 	switch (UFS_SB(sb)->s_flags & UFS_ST_MASK) {
 	case UFS_ST_SUNOS:
-		if (fs32_to_cpu(sb, usb3->fs_postblformat == UFS_42POSTBLFMT)) {
+		if (fs32_to_cpu(sb, usb3->fs_postblformat) == UFS_42POSTBLFMT) {
 			usb1->fs_u0.fs_sun.fs_state = cpu_to_fs32(sb, value);
 			break;
 		}

-- 
