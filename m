Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbXEJJkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbXEJJkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbXEJJka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:40:30 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:31751 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbXEJJk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kV8/lqOiBy96xHx/XvIWvNVWU7Dh2NlDA1aFnulIC6sCLe+Jik/VEVtWxoRSAME+SE3NxIMVLEF8JLrAI7Xl5I2WFbmczZpK/V9mSzlYHSCEIFUyu0q1SkbtU5VU7BcGJcFWxxnJyI+n+vOi0mNBTD/Lf7b3lRaBgyXfTQr2ygw=
Message-ID: <b6a2187b0705100240h3916f206l22cb59a4012fabc6@mail.gmail.com>
Date: Thu, 10 May 2007 17:40:28 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: PCI changed from 2.6.10-rc1 to 2.6.10-rc2. help needed.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to get the Brooktrout TR1034 fax card to run with
Linux-2.6.21, but it just won't run, so I downgraded to 2.6.9 and it
seems to load just fine. Then I tried 2.6.10-rc1, and with a few
changes, it seems to work. But, when I tried 2.6.10-rc2, it failed.

Here's what I patched to make it run from 2.6.9 to 2.6.10-rc1.

I need some guidance to try to get the card to work, hopefully with
2.6.21 eventually.

Is this possible? It seems the PCI layer has changed quite a lot and I
doubt a quick patch can do the job. I can get the module to compile
and load, but since other bits are in binary, I've no way to confirm
that they're ok. It's tough to get vendor to do a 2.6.21. version.

Thanks,
Jeff.


--- kerndep.c.2610      2007-05-10 14:26:18 +0800
+++ kerndep.c.269       2007-05-08 21:52:09 +0800
@@ -597,7 +597,7 @@

 void *kerndep_pci_find_dev(unsigned vend_id,unsigned dev_id,void *dev)
 {
-    return(pci_get_device(vend_id,dev_id,dev));
+    return(pci_find_device(vend_id,dev_id,dev));
 }

 unsigned kerndep_dev_vend_id(void *dev)
@@ -655,7 +655,6 @@

 int kerndep_pci_read_config_word(void *dev,unsigned off,void *addr)
 {
-    pci_dev_put(dev);
     return(pci_read_config_word(dev,off,addr));
 }

@@ -825,8 +824,8 @@

 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #define PARM_DECL_INT(v) module_param(v,int,0)
-#define PARM_DECL_INT_ARRAY_8(v) module_param_array(v,int,&isa_addr_size,0)
-#define PARM_DECL_INT_ARRAY_64(v) module_param_array(v,int,&mod_val_size,0)
+#define PARM_DECL_INT_ARRAY_8(v) module_param_array(v,int,isa_addr_size,0)
+#define PARM_DECL_INT_ARRAY_64(v) module_param_array(v,int,mod_val_size,0)
 int isa_addr_size;
 int mod_val_size;
 #else
