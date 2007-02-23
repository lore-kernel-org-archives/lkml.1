Return-Path: <linux-kernel-owner+w=401wt.eu-S965063AbXBWQgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063AbXBWQgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 11:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965134AbXBWQgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 11:36:53 -0500
Received: from relay2.uni-heidelberg.de ([129.206.210.211]:41564 "EHLO
	relay2.uni-heidelberg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965063AbXBWQgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 11:36:51 -0500
X-Greylist: delayed 4302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 11:36:51 EST
Message-ID: <20070223162505.rdtobeij48o40sow@wwwmail.urz.uni-heidelberg.de>
Date: Fri, 23 Feb 2007 16:25:05 +0100
From: Sacher Khoudari <Sacher.Khoudari@stud.uni-heidelberg.de>
To: linux-kernel@vger.kernel.org
Subject: isapnp: broken API
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_3gj2qgf2gtht"
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

--=_3gj2qgf2gtht
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hi!

I've lately tried to run a ISA card (HP 82341, with drivers from the  
Linux GPIB project, latest version), but the module failed to get  
loaded. Modprobe said it couldn't find a symbol (Undefined symbol  
'isapnp_read_byte'), although it was present in /boot/System.map and  
/proc/kallsyms. After some googleing, trying to compile a new kernel,  
looking into code, etc, I found out what the problem was. The function  
"isapnp_read_byte" was no longer been exported. You can find the line  
in question here [1] (note the #if 0). The patch that did this change  
was this [2] one.

I'm not sure, but as I understand it, it was not intended to comment  
this EXPORT_SYMBOLS(isapnp_read_byte) out. So it probably just  
happened by accident?

I've attached a patch for the latest stable kernel (2.6.20.1). Please  
apply it.


Greetings
Sacher



[1] http://www.gelato.unsw.edu.au/lxr/source/drivers/pnp/isapnp/core.c#L948
[2] http://lkml.org/lkml/2005/6/20/307

--=_3gj2qgf2gtht
Content-Type: text/x-patch;
	charset=UTF-8;
	name="isapnp.patch"
Content-Disposition: attachment;
	filename="isapnp.patch"
Content-Transfer-Encoding: 7bit

--- linux-2.6.20.1/drivers/pnp/isapnp/core.c.old	2007-02-23 16:20:46.000000000 +0100
+++ linux-2.6.20.1/drivers/pnp/isapnp/core.c	2007-02-23 16:21:25.000000000 +0100
@@ -943,9 +943,7 @@
 EXPORT_SYMBOL(isapnp_present);
 EXPORT_SYMBOL(isapnp_cfg_begin);
 EXPORT_SYMBOL(isapnp_cfg_end);
-#if 0
 EXPORT_SYMBOL(isapnp_read_byte);
-#endif
 EXPORT_SYMBOL(isapnp_write_byte);
 
 static int isapnp_read_resources(struct pnp_dev *dev, struct pnp_resource_table *res)

--=_3gj2qgf2gtht--
