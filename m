Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYKIQXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYKIQXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYKIQXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:23:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:35481 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbYKIQXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:23:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=exqP7R+e7H5yzi+K6n3QQLhaQaMRgJz9pjuqyXDZh4zPBm6bObfG6EngPzq10uaW0K
         9QPaNUMqXIAfXWj4kPv5YW5CWFRP/1mD7HSE80dNOSihVr3AQlIOoIhZwOFs36ermt08
         bW0OHXxZktoAa9qIiSJmcHFL0DKr4pVo95bpU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/6] rz1000: apply chipset quirks early
Date: Sun, 9 Nov 2008 15:03:48 +0100
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain> <491083E9.60305@ru.mvista.com> <49109AC9.5090406@ru.mvista.com>
In-Reply-To: <49109AC9.5090406@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811091503.48842.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2008, Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >> Index: b/drivers/ide/rz1000.c
> >> ===================================================================
> >> --- a/drivers/ide/rz1000.c
> >> +++ b/drivers/ide/rz1000.c
> >> @@ -22,34 +22,48 @@
> >>  
> >>  #define DRV_NAME "rz1000"
> >>  
> >> -static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
> >> +static unsigned int __devinit rz1000_init_chipset(struct pci_dev *dev)
> 
> >    Hm, this is not a real init_chipset() method and it does just one 
> > thing -- disables readahead, so rz1000_disable_readahead() or something 
> > of that sort seems like a better name...
> 
>     Hm, 'unsigned' result type wasn't terribly helpful here as well. :-)

Agreed, v1->v2 interdiff:

...
v2:
* unsigned int rz1000_init_chipset() -> int rz1000_disable_readahead()
  per Sergei's suggestion.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
...
diff -u b/drivers/ide/rz1000.c b/drivers/ide/rz1000.c
--- b/drivers/ide/rz1000.c
+++ b/drivers/ide/rz1000.c
@@ -22,7 +22,7 @@
 
 #define DRV_NAME "rz1000"
 
-static unsigned int __devinit rz1000_init_chipset(struct pci_dev *dev)
+static int __devinit rz1000_disable_readahead(struct pci_dev *dev)
 {
 	u16 reg;
 
@@ -52,7 +52,7 @@
 	if (rc)
 		return rc;
 
-	if (rz1000_init_chipset(dev)) {
+	if (rz1000_disable_readahead(dev)) {
 		d.host_flags |= IDE_HFLAG_SERIALIZE;
 		d.host_flags |= IDE_HFLAG_NO_UNMASK_IRQS;
 	}
