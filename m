Return-Path: <linux-kernel-owner+w=401wt.eu-S934352AbXEGPWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbXEGPWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934311AbXEGPWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:22:44 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:54440 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934345AbXEGPWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:22:44 -0400
Subject: [PATCH 2.6.21-mm1]  remove unionfs reference to SLAB_CTOR_VERIFY
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jsipek@cs.sunysb.edu
Cc: Eric Whitney <eric.whitney@hp.com>
Content-Type: text/plain; charset=UTF-8
Organization: HP/OSLO
Date: Mon, 07 May 2007 11:22:32 -0400
Message-Id: <1178551352.5079.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With unionfs included as a module, 2.6.21-mm1 build broke with:

fs/unionfs/super.c: In function ‘init_once’:
fs/unionfs/super.c:822: error: ‘SLAB_CTOR_VERIFY’ undeclared (first use in this function)
fs/unionfs/super.c:822: error: (Each undeclared identifier is reported only oncefs/unionfs/super.c:822: error: for each function it appears in.)

Looks like it missed the removal of SLAB_CTOR_VERIFY.  

This patch matches how the situation was addressed elsewhere
throughout the kernel.  Fixes the problem for me...

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 fs/unionfs/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: Linux/fs/unionfs/super.c
===================================================================
--- Linux.orig/fs/unionfs/super.c	2007-05-07 10:00:21.000000000 -0400
+++ Linux/fs/unionfs/super.c	2007-05-07 10:40:51.000000000 -0400
@@ -819,8 +819,7 @@ static void init_once(void *v, struct km
 {
 	struct unionfs_inode_info *i = v;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&i->vfs_inode);
 }
 


