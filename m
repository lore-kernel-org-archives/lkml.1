Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbXHCUW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbXHCUW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbXHCUWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:22:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:10321 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXHCUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer;
        b=CwS114H+XbdeOyZXjeCAGs3NmnfnbDpN7/4mR+nj6/EBndXNoyVBXsawivDcxKTSPma6V8GFTySdsBDAFEdRISzk/YVU0ekOFi/n0FFi5ydhCOGnIxZ+MYcaeU0iihRaQEjIccogY7D/VR0MOzGmkinW9KiwdqG3pYIJDhyE9uc=
Subject: [PATCH] pxa2xx PCMCIA timing issue on iPAQ H5550
From: Milan Plzik <milan.plzik@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pcmcia@lists.infradead.org
Content-Type: multipart/mixed; boundary="=-QeL1i628lIyIZhr3TMzm"
Date: Fri, 03 Aug 2007 22:22:12 +0200
Message-Id: <1186172532.32154.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QeL1i628lIyIZhr3TMzm
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

  Good day,

  recently I've been trying to get working PCMCIA interface on H5000
ipaq series, using dual PCMCIA sleeve. So far things work correctly, but
I had to do one modification to drivers/pcmcia/pxa2xx_base.c to get the
interface working with orinoco gold PCMCIA card (wired pcnet_cs ethernet
card worked even without this modification). Patch attached.

  The issue has something to do with assert time on PCMCIA bus, but I'm
not really sure what -- I found the working value just by trial&error
approach. I'm not sure how is the assert value in pxa2xx_mcxx_asst
calculated (I know, simple formula, but the reason why is it calculated
that way is not obvious for me), neither that my modification is
correct. It just works with iPAQ. 

  Please include me in Cc, as I'm not subscribed to neither of mailing
lists.

  Best regards,
	Milan Plzik


--=-QeL1i628lIyIZhr3TMzm
Content-Disposition: attachment; filename=pcmcia_timing_fix.patch
Content-Type: text/x-patch; name=pcmcia_timing_fix.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: drivers/pcmcia/pxa2xx_base.c
===================================================================
RCS file: /cvs/linux/kernel26/drivers/pcmcia/pxa2xx_base.c,v
retrieving revision 1.12
diff -a -u -r1.12 pxa2xx_base.c
--- drivers/pcmcia/pxa2xx_base.c	10 Mar 2007 11:46:02 -0000	1.12
+++ drivers/pcmcia/pxa2xx_base.c	3 Aug 2007 20:04:10 -0000
@@ -59,7 +59,7 @@
 				     u_int mem_clk_10khz)
 {
 	u_int code = pcmcia_cycle_ns * mem_clk_10khz;
-	return (code / 300000) + ((code % 300000) ? 1 : 0) - 1;
+	return (code / 300000) + ((code % 300000) ? 1 : 0) + 1;
 }
 
 static inline u_int pxa2xx_mcxx_setup(u_int pcmcia_cycle_ns,

--=-QeL1i628lIyIZhr3TMzm--

