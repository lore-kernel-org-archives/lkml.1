Return-Path: <linux-kernel-owner+w=401wt.eu-S966269AbYD1V2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966269AbYD1V2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965817AbYD1V1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:27:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:24926 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965773AbYD1V1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Lcj6H708oNdi2fqQfoWrgdO5CPFe4e5p+EZnL7lJTgdnEBmmJeH+wEUnbh91M0Oq1qKD6gZ8j1zuw0QxreCbdUCEn80Qfasp1rDwhOtPvfPm/D6xlUbHV+K5K/Og8P9p72I2BllhcYXcLM8N/zFJKyPNJJX5c73tjD/34YyjiBo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: fix au1xxx-ide breakage
Date: Mon, 28 Apr 2008 23:42:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804282342.04205.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 28 April 2008, Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> > Fix these warnings emitted when compiling drivers/ide/mips/au1xxx-ide.c:
> 
> > include/asm/mach-au1x00/au1xxx_ide.h:137: warning: 'auide_tune_drive' declared 
> > `static' but never defined
> > include/asm/mach-au1x00/au1xxx_ide.h:138: warning: 'auide_tune_chipset' declared
> >  `static' but never defined
> 
> > by wiping out the whole "function prototyping" section from the header file
> > <asm-mips/mach-au1x00/au1xxx_ide.h> as it mostly declared functions that are
> > already dead in the IDE driver; move the only useful prototype into the driver.
> > 
> > Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> > ---
> > I'm not sure thru which tree this should go -- probably thru Linux/MIPS one...
> 
> > Bart, au1xxx-ide-fix-mwdma-support.patch will probably need to be updated to
> > remove that added prototype since it won't be needed anymore...
> 
>     Which you haven't done either in that patch or in 
> au1xxx-ide-use-init_dma-method.patch. So, face the consequences:
> 
> drivers/ide/mips/au1xxx-ide.c:456: error: conflicting types for 'auide_ddma_init'
> drivers/ide/mips/au1xxx-ide.c:51: error: previous declaration of
> 'auide_ddma_init' was here
> drivers/ide/mips/au1xxx-ide.c:456: error: conflicting types for 'auide_ddma_init'
> drivers/ide/mips/au1xxx-ide.c:51: error: previous declaration of
> 'auide_ddma_init' was here
> drivers/ide/mips/au1xxx-ide.c:51: warning: 'auide_ddma_init' used but never
> defined

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/mips/au1xxx-ide.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -48,8 +48,6 @@
 
 static _auide_hwif auide_hwif;
 
-static int auide_ddma_init(_auide_hwif *auide);
-
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA)
 
 void auide_insw(unsigned long port, void *addr, u32 count)
