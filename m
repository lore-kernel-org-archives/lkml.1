Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYJPP06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYJPP06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYJPP0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:26:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:4845 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYJPP0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=O3BQiETl1P7RJ+llaS9qW2Smrwyrwk4MBoFLf901LiezQNBHSQwdYKEFXtzFhukew2
         Nmp20IyLhs4t9aARI0mBDJrc/gQyKzUEeW9otDMz//t8Jl9RZ90uT1OPRmTdqou8+9Av
         /ZzwLtptvMjw9tAOcNCgrEDPUGr98e9wxRMyk=
Date: Thu, 16 Oct 2008 16:26:26 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, jdike@addtoit.com
Subject: [Patch] uml: fix one compile error
Message-ID: <20081016152626.GD13374@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixed the following compile error:

  CC      arch/um/sys-i386/signal.o
  /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c: In
function 'copy_sc_from_user':
/home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
warning: dereferencing 'void *' pointer
/home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
error: request for member '_fxsr_env' in something not a structure or
union


Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: jdike@addtoit.com

---
diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
index fd0c25a..1296473 100644
--- a/arch/um/sys-i386/signal.c
+++ b/arch/um/sys-i386/signal.c
@@ -179,7 +179,8 @@ static int copy_sc_from_user(struct pt_regs *regs,
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
 
-		err = copy_from_user(&fpx, &sc.fpstate->_fxsr_env[0],
+		err = copy_from_user(&fpx,
+			&((struct _fpstate __user *)sc.fpstate)->_fxsr_env[0],
 				     sizeof(struct user_fxsr_struct));
 		if (err)
 			return 1;

