Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZJLBve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZJLBve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 21:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZJLBvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 21:51:31 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:49087 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZJLBvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 21:51:31 -0400
Message-ID: <4AD28B51.7020903@oracle.com>
Date: Sun, 11 Oct 2009 18:50:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, gregkh@suse.de,
       linux-pcmcia@lists.infradead.org
Subject: [PATCH] pcmcia: fix controller printk format warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AD28B69.0110:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new pcmcia printk format warnings:
[This has now moved from linux-next to mainline.
Originally sent 2009-SEP-17.]

drivers/pcmcia/i82365.c:1055: warning: format '%#x' expects type 'unsigned int', but argument 6 has type 'phys_addr_t'
drivers/pcmcia/i82365.c:1055: warning: format '%#x' expects type 'unsigned int', but argument 7 has type 'phys_addr_t'
drivers/pcmcia/tcic.c:734: warning: format '%#x' expects type 'unsigned int', but argument 6 has type 'phys_addr_t'
drivers/pcmcia/tcic.c:734: warning: format '%#x' expects type 'unsigned int', but argument 7 has type 'phys_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pcmcia/i82365.c |    4 ++--
 drivers/pcmcia/tcic.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20090917.orig/drivers/pcmcia/tcic.c
+++ linux-next-20090917/drivers/pcmcia/tcic.c
@@ -732,8 +732,8 @@ static int tcic_set_io_map(struct pcmcia
     u_short base, len, ioctl;
     
     debug(1, "SetIOMap(%d, %d, %#2.2x, %d ns, "
-	  "%#x-%#x)\n", psock, io->map, io->flags,
-	  io->speed, io->start, io->stop);
+	  "%#llx-%#llx)\n", psock, io->map, io->flags, io->speed,
+	  (unsigned long long)io->start, (unsigned long long)io->stop);
     if ((io->map > 1) || (io->start > 0xffff) || (io->stop > 0xffff) ||
 	(io->stop < io->start)) return -EINVAL;
     tcic_setw(TCIC_ADDR+2, TCIC_ADR2_INDREG | (psock << TCIC_SS_SHFT));
--- linux-next-20090917.orig/drivers/pcmcia/i82365.c
+++ linux-next-20090917/drivers/pcmcia/i82365.c
@@ -1053,8 +1053,8 @@ static int i365_set_io_map(u_short sock,
     u_char map, ioctl;
     
     debug(1, "SetIOMap(%d, %d, %#2.2x, %d ns, "
-	  "%#x-%#x)\n", sock, io->map, io->flags,
-	  io->speed, io->start, io->stop);
+	  "%#llx-%#llx)\n", sock, io->map, io->flags, io->speed,
+	  (unsigned long long)io->start, (unsigned long long)io->stop);
     map = io->map;
     if ((map > 1) || (io->start > 0xffff) || (io->stop > 0xffff) ||
 	(io->stop < io->start)) return -EINVAL;
