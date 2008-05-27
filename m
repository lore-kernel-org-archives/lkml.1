Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbYEZTYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbYEZTYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYEZTXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:23:53 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:33000 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbYEZTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=iPk9iF+ByV4dSwBrCD1TYwAMmNOELy3Q7L4UYo+bXJo1GaMxkWq29MofJXcMDuVeBNs6AxKzTrdFcDt63PM9xMG4wMO2TJQf+Du68AdnqnY6eCx9rFQ6ON6sBuHYxP1jOcCGUs1yehI6Q24HOFey8a1jRS0CgIdSzOt6tMyZF8g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 04/22] ide: add ide_deprecated_find_port() helper
Date: Tue, 27 May 2008 20:36:10 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain> <20080116232624.9166.73929.sendpatchset@localhost.localdomain> <483431E4.7020307@ru.mvista.com>
In-Reply-To: <483431E4.7020307@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805272036.10152.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > * Factor out code for finding ide_hwifs[] slot from ide_register_hw()
> >   to ide_deprecated_find_port().
> 
> > * Convert bast-ide, ide-cs and delkin_cb host drivers to use ide_device_add()
> >   instead of ide_register_hw() (while at it drop doing "ide_unregister()" loop
> >   which tries to unregister _all_ IDE interfaces if useable ide_hwifs[] slot
> >   cannot be find).
> 
>     Er... this patch didn't actually drop that loop (late remark :-).
> 
> > This patch leaves us with only two ide_register_hw() users:
> > - drivers/macintosh/mediabay.c
> > - drivers/ide/ide.c
> 
>     I wonder whether ide_register_hw() was much good at all since it didn't 
> actually permit to register chips using MMIO: you couldn't pass that info via 
> 'hw' and it set 'hwif->noprobe' to 0, thus giving you no chance to skip 
> probing which wouldn't work anyway; for the same reason it was no good for DMA 
> capable chips since you had not time to install ide_dma_check() and other DMA 
> methods. Am I right here?

Yes but please remember that before we started the major surgeries
ide_register_hw() operated in two modes:

- "post-init-probe" which worked like described above

- "pre-init-probe" which allowed host drivers to do all setup
   (as the probing was done later by ide_generic host driver)

and the vast majority of host drivers used "pre-init-probe" mode
(which doesn't change the fact that ide_register_hw() was not good
anyway since it had a number of other problems).

Thanks,
Bart
