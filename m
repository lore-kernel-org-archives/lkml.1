Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZFYOx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZFYOx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZFYOxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:53:18 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2097 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbZFYOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:53:17 -0400
Subject: Re: [PATCH 16/19] drivers/staging: Use PCI_VDEVICE
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <4A438898.8030007@gmail.com>
References: <cover.1245906151.git.joe@perches.com>
	 <127986351d52895b618ad6bc31a704bc34ef2d97.1245906153.git.joe@perches.com>
	 <4A438898.8030007@gmail.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 07:53:16 -0700
Message-Id: <1245941596.395.33.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 16:24 +0200, Jiri Slaby wrote:
> > --- a/drivers/staging/vt6655/device_main.c
> > +++ b/drivers/staging/vt6655/device_main.c
> > @@ -344,7 +344,7 @@ static CHIP_INFO chip_info_table[]= {
> >  };
> >  
> >  static struct pci_device_id device_id_table[] __devinitdata = {
> > -{ 0x1106, 0x3253, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (int)&chip_info_table[0]},
> > +{ PCI_VDEVICE(VIA, 0x3253), (int)&chip_info_table[0]},
> 
> Hmm, pointer chopped to 4 bytes on 64-bit. Could you fix that up too?

In addition to original patch

drivers/staging/vt6655: cast pci_device_id driver_data to appropriate type
    
Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 7a2377c..a347087 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -344,7 +344,7 @@ static CHIP_INFO chip_info_table[]= {
 };
 
 static struct pci_device_id device_id_table[] __devinitdata = {
-{ PCI_VDEVICE(VIA, 0x3253), (int)&chip_info_table[0]},
+{ PCI_VDEVICE(VIA, 0x3253), (kernel_ulong_t)&chip_info_table[0]},
 { 0, }
 };
 #endif


