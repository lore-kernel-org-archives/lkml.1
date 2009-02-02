Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZBBUKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZBBUKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZBBUKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:10:35 -0500
Received: from edu.joroinen.fi ([194.89.68.130]:50428 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbZBBUKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:10:35 -0500
X-Greylist: delayed 1398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Feb 2009 15:10:34 EST
Date: Mon, 2 Feb 2009 21:47:14 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix sata_sil compilation error with libata debug enabled (2.6.29-rcX)
Message-ID: <20090202194714.GN15052@edu.joroinen.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

I tried compiling 2.6.29-rc1 and 2.6.29-rc3 with libata debugging enabled
and got the following error:

  CC [M]  drivers/ata/sata_sil.o
drivers/ata/sata_sil.c: In function 'sil_fill_sg':
drivers/ata/sata_sil.c:327: error: 'pi' undeclared (first use in this function)
drivers/ata/sata_sil.c:327: error: (Each undeclared identifier is reported only once
drivers/ata/sata_sil.c:327: error: for each function it appears in.)
make[2]: *** [drivers/ata/sata_sil.o] Error 1
make[1]: *** [drivers/ata] Error 2
make: *** [drivers] Error 2

include/linux/libata.h has the following enabled:

#define ATA_DEBUG
#define ATA_VERBOSE_DEBUG
#define ATA_IRQ_TRAP

The attached patch fixes the compilation.. I'm not sure if it's the correct
fix, but looking at the code it seems correct.. or at least makes the
code compile for me :)

-- Pasi

--HlL+5n6rz5pIUxbD
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="sata_sil-libata-debug-compilation-error.patch"

--- drivers/ata/sata_sil.c.orig	2009-02-02 16:59:26.000000000 +0200
+++ drivers/ata/sata_sil.c	2009-02-02 21:37:12.000000000 +0200
@@ -324,7 +324,7 @@
 
 		prd->addr = cpu_to_le32(addr);
 		prd->flags_len = cpu_to_le32(sg_len);
-		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, sg_len);
+		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", si, addr, sg_len);
 
 		last_prd = prd;
 		prd++;

--HlL+5n6rz5pIUxbD--
