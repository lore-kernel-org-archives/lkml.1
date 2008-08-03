Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYHCOSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYHCOSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYHCOSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:18:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:16273 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbYHCOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:18:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=swIN+oJVIoDymrV+2tGUroR1pn2LSn/9qqlfR7mM7eJB78lAhKm060f3lqZBaVF/VU
         y5QsB1oKwhpKjicnQudAorzAQ+JlZEnF/Qt+ptttaNMKCp39xnZe8pakeqaoE/zFjIhH
         QcrzZprmFiuc1txin2bZskjQdDQrnSLgP0sQY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/2] ide: add proper PCI PM support
Date: Sun, 3 Aug 2008 16:15:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200808021917.04847.bzolnier@gmail.com> <200808022249.38969.rjw@sisk.pl>
In-Reply-To: <200808022249.38969.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808031615.38477.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 August 2008, Rafael J. Wysocki wrote:
> On Saturday, 2 of August 2008, Bartlomiej Zolnierkiewicz wrote:
> > * Keep pointer to ->init_chipset method also in
> >   struct ide_host and set it in ide_host_alloc_all().
> > 
> > * Add ide_pci_suspend() and ide_pci_resume() helpers
> >   (default ->suspend and ->resume implementations).
> > 
> > * ->init_chipset can no longer be marked __devinit.
> > 
> > * Add proper PCI PM support to IDE PCI host drivers
> >   (rz1000.c and tc86c001.c are skipped for now since
> >   they need to be converted from using ->init_hwif
> >   to use ->init_chipset instead).
> 
> Well, first, the work on improving the PCI PM support by IDE drivers is much
> appreciated.
> 
> Still, since you're adding new routines etc., it may be a good time to
> implement them using the new PM framework, as defined in
> include/linux/pm.h (please also have a look at drivers/pci/pci-driver.c for the
> PCI bus type's PM callbacks implementation details).  Unfortunately, it's not
> been well documented yet, so if you have any questions, please ask.
> 
> In fact, we need some example implementations of the new PM callbacks and
> since you know the drivers in question very well, we could use your
> implementations as examples, if you don't mind.  [Certainly, they would be
> better than PM callbacks written by me for any driver. ;-) ]

Thanks for reviewing the patch.  I'll take a look into converting it to
use new PM infrastructure (it may take a while so please be patient).
