Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYGVRn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYGVRn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYGVRne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:43:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:41639 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYGVRnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=HpySCgzy9tKQc3ACSS7byn2Qk7OzGeH1PKkGygbNlildVrKd55jOpn1HUJNL7zCSyG
         Hm9+rZ0Mc7u4O/UIJoBHkaJVSNhuv1OdJV7Q059hidUN+kLdo4W8MsaZEykGyWkzitHl
         PkPy13BZQ8xUiecYv5ddlWSBJtYaMxRFh+fDA=
Date: Tue, 22 Jul 2008 18:41:52 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] uml: fix another build error
Message-ID: <20080722174152.GF3081@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed this error:

  CC      arch/um/drivers/vde_user.o
  /home/wangcong/Projects/linux-2.6/arch/um/drivers/vde_user.c: In
function ‘vde_init_libstuff’:
/home/wangcong/Projects/linux-2.6/arch/um/drivers/vde_user.c:81:
error: implicit declaration of function ‘kmalloc’
/home/wangcong/Projects/linux-2.6/arch/um/drivers/vde_user.c:81:
warning: assignment makes pointer from integer without a cast
make[2]: *** [arch/um/drivers/vde_user.o] Error 1
make[1]: *** [arch/um/drivers/vde_user.ko] Error 2
make: *** [sub-make] Error 2

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: jdike@addtoit.com

---
diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
index 56533db..744eacf 100644
--- a/arch/um/drivers/vde_user.c
+++ b/arch/um/drivers/vde_user.c
@@ -78,7 +78,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
 {
 	struct vde_open_args *args;
 
-	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
+	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
 		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
 		       "allocation failed");
