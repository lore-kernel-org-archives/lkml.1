Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608Ab0A2NNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0A2NNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 08:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126Ab0A2NNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 08:13:17 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58388 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089Ab0A2NNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 08:13:16 -0500
Date: Fri, 29 Jan 2010 14:13:25 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, "Sergey S. Kostyliov" <rathamahata@php4.ru>
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] Obsolete config in kernel source (BEFS_RW)
Message-ID: <20100129131325.GA13907@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	The BEFS filesystem Code has a check for CONFIG_BEFS_RW which
seems to have no counterpart in linux KConfig in git's history. Maybe
you want to remove the check and always assume it would fail (as is
done with the attached patch).

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger


--BXVAT5kNtrzKuDFl
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Drop-obsolete-config-BEFS_RW.patch"

>From 0f1656a6df5ffbfcc22b6a73522b4c41b190ac7a Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 29 Jan 2010 14:03:12 +0100
Subject: [PATCH] Drop obsolete config BEFS_RW

CONFIG_BEFS_RW doesn't have any counterpart in KConfig since virtually
ever and there's only one place in the kernel where it is (still?)
checked.

This patch removes the obsolete check (alwazs evaluates to true).

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 fs/befs/linuxvfs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 33baf27..4c3e342 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -778,13 +778,11 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 
 	befs_debug(sb, "---> befs_fill_super()");
 
-#ifndef CONFIG_BEFS_RW
 	if (!(sb->s_flags & MS_RDONLY)) {
 		befs_warning(sb,
 			     "No write support. Marking filesystem read-only");
 		sb->s_flags |= MS_RDONLY;
 	}
-#endif				/* CONFIG_BEFS_RW */
 
 	/*
 	 * Set dummy blocksize to read super block.
-- 
1.6.3.3


--BXVAT5kNtrzKuDFl--
