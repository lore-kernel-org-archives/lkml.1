Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYG0PfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYG0PfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 11:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYG0PfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 11:35:02 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:44409 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYG0PfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 11:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=CsdrtCdA5MsFYxbUicAHi4DIjapBSr410NY91dG33KDRAHVOQCOIxYiHGnRUsxumZk
         RVSgTq6haLPQNP36LJS8BGR6mZ337pg0WEwJLg16jfw8dyfMsvA4xrVAE80wtZVMjhaR
         5D/dSC1/KgCV4BpM9VqWISDWqY7HIunZddIi4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 01/10] ide: sanitize struct ide_port_ops documentation
Date: Sun, 27 Jul 2008 17:03:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain> <20080726091854.a6ce1268.randy.dunlap@oracle.com>
In-Reply-To: <20080726091854.a6ce1268.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807271703.13109.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 July 2008, Randy Dunlap wrote:
> On Sat, 26 Jul 2008 15:40:10 +0200 Bartlomiej Zolnierkiewicz wrote:
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > some easy/trivial changes just to keep the ball rolling...
> > 
> >  include/linux/ide.h |   27 ++++++++++++++++++---------
> >  1 file changed, 18 insertions(+), 9 deletions(-)
> > 
> > Index: b/include/linux/ide.h
> > ===================================================================
> > --- a/include/linux/ide.h
> > +++ b/include/linux/ide.h
> > @@ -508,24 +508,33 @@ struct ide_tp_ops {
> >  
> >  extern const struct ide_tp_ops default_tp_ops;
> >  
> > +/**
> > + * struct ide_port_ops - IDE port operations
> > + *
> > + * init_dev:		host specific initialization of a device
> 
> Good idea, Bart, but please put an '@' in front of each field name, e.g.,
> 
>  * @init_dev:		host specific ...

Doh, I knew I was forgetting something.  Fixed.

> See Documentation/kernel-doc-nano-HOWTO.txt for details (or ask).

Thanks for the pointer.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: sanitize struct ide_port_ops documentation (take 2)

v2:
Add missing '@'-s.  (Noticed by Randy Dunlap)

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -508,24 +508,33 @@ struct ide_tp_ops {
 
 extern const struct ide_tp_ops default_tp_ops;
 
+/**
+ * struct ide_port_ops - IDE port operations
+ *
+ * @init_dev:		host specific initialization of a device
+ * @set_pio_mode:	routine to program host for PIO mode
+ * @set_dma_mode:	routine to program host for DMA mode
+ * @selectproc:		tweaks hardware to select drive
+ * @reset_poll:		chipset polling based on hba specifics
+ * @pre_reset:		chipset specific changes to default for device-hba resets
+ * @resetproc:		routine to reset controller after a disk reset
+ * @maskproc:		special host masking for drive selection
+ * @quirkproc:		check host's drive quirk list
+ *
+ * @mdma_filter:	filter MDMA modes
+ * @udma_filter:	filter UDMA modes
+ *
+ * @cable_detect:	detect cable type
+ */
 struct ide_port_ops {
-	/* host specific initialization of a device */
 	void	(*init_dev)(ide_drive_t *);
-	/* routine to program host for PIO mode */
 	void	(*set_pio_mode)(ide_drive_t *, const u8);
-	/* routine to program host for DMA mode */
 	void	(*set_dma_mode)(ide_drive_t *, const u8);
-	/* tweaks hardware to select drive */
 	void	(*selectproc)(ide_drive_t *);
-	/* chipset polling based on hba specifics */
 	int	(*reset_poll)(ide_drive_t *);
-	/* chipset specific changes to default for device-hba resets */
 	void	(*pre_reset)(ide_drive_t *);
-	/* routine to reset controller after a disk reset */
 	void	(*resetproc)(ide_drive_t *);
-	/* special host masking for drive selection */
 	void	(*maskproc)(ide_drive_t *, int);
-	/* check host's drive quirk list */
 	void	(*quirkproc)(ide_drive_t *);
 
 	u8	(*mdma_filter)(ide_drive_t *);
