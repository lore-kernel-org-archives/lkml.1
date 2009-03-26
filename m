Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbZCZX1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbZCZX1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760407AbZCZX0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:26:51 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48766 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629AbZCZX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lj/RvDLwihzq6w6o1anM7Wrej0qnr0PAIlCNNjE2z952vKhvdzVX01FOreNjs+hAb9
         7AIfb/SfWxbdCPlEVHneXbzot491An+H7MYq0iKPzsRgv1TYNTyg+Py04Ub2NFg2aba0
         iBLitWK0fbiMUpIWd6+LJmqIaysftV1D/KmxU=
Date: Fri, 27 Mar 2009 02:34:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove INIT_KIOCTX
Message-ID: <20090326233412.GA26012@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unused after 20dcae32439384b6863c626bb3b2a09bed65b33e aka
"[PATCH] aio: remove kioctx from mm_struct".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/init_task.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -14,19 +14,6 @@
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
-#define INIT_KIOCTX(name, which_mm) \
-{							\
-	.users		= ATOMIC_INIT(1),		\
-	.dead		= 0,				\
-	.mm		= &which_mm,			\
-	.user_id	= 0,				\
-	.next		= NULL,				\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER(name.wait), \
-	.ctx_lock	= __SPIN_LOCK_UNLOCKED(name.ctx_lock), \
-	.reqs_active	= 0U,				\
-	.max_reqs	= ~0U,				\
-}
-
 #define INIT_MM(name) \
 {			 					\
 	.mm_rb		= RB_ROOT,				\
