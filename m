Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYHMWMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYHMWMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 18:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYHMWMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 18:12:07 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:54998 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYHMWMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 18:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=yCymXW0/YhFbP/22Hhxzdp+87dwezFcpeFyjj+KUIB1JgCyJYv1ZQ3ZMvHfWQ+0Tek
         kcieMA1JYIEpYS0OkefQazWUba98x/0UyOIIxdwhsAz/n0ebA57UZn4gULmaseLizCwP
         LU21HOnoN1ZHg6CJQUijL+aDSM6tFVUEjNQIM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] ide: remove CONFIG_BLK_DEV_IDE config option
Date: Thu, 14 Aug 2008 00:09:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200808132323.02369.bzolnier@gmail.com> <20080813213149.GC7071@cs181140183.pp.htv.fi> <200808140005.03603.bzolnier@gmail.com>
In-Reply-To: <200808140005.03603.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808140009.26857.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 August 2008, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 13 August 2008, Adrian Bunk wrote:
> > On Wed, Aug 13, 2008 at 11:23:02PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > Because hd.c was moved to drivers/block/ this config option
> > > is superfluous now and may be removed.
> > > 
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > ---
> > >  drivers/ide/Kconfig |   38 ++------------------------------------
> > >  1 file changed, 2 insertions(+), 36 deletions(-)
> > >...
> > 
> > /me wonders why your patch doesn't touch drivers/ide/Makefile
> 
> This is a very good question...
> 
> v2 interdiff:

Now for real...  [ I need some sleep badly... ]

...
v2:
Fix drivers/ide/Makefile (noticed by Adrian Bunk).

Cc: Adrian Bunk <bunk@kernel.org>
...

only in patch2:
unchanged:
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -15,14 +15,14 @@ ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide
 ide-core-$(CONFIG_IDE_PROC_FS)		+= ide-proc.o
 ide-core-$(CONFIG_BLK_DEV_IDEACPI)	+= ide-acpi.o
 
-obj-$(CONFIG_BLK_DEV_IDE)		+= ide-core.o
+obj-$(CONFIG_IDE)			+= ide-core.o
 
 ifeq ($(CONFIG_IDE_ARM), y)
 	ide-arm-core-y += arm/ide_arm.o
 	obj-y += ide-arm-core.o
 endif
 
-obj-$(CONFIG_BLK_DEV_IDE)		+= legacy/ pci/
+obj-$(CONFIG_IDE)			+= legacy/ pci/
 
 obj-$(CONFIG_IDEPCI_PCIBUS_ORDER)	+= ide-scan-pci.o
 
@@ -31,7 +31,7 @@ ifeq ($(CONFIG_BLK_DEV_CMD640), y)
 	obj-y += cmd640-core.o
 endif
 
-obj-$(CONFIG_BLK_DEV_IDE)		+= ppc/
+obj-$(CONFIG_IDE)			+= ppc/
 obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
@@ -54,4 +54,4 @@ ifeq ($(CONFIG_BLK_DEV_PLATFORM), y)
 	obj-y += ide-platform-core.o
 endif
 
-obj-$(CONFIG_BLK_DEV_IDE)		+= arm/ mips/
+obj-$(CONFIG_IDE)			+= arm/ mips/
