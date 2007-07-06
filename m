Return-Path: <linux-kernel-owner+w=401wt.eu-S1763742AbXGFRxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763742AbXGFRxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763982AbXGFRw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:52:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:48975 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763742AbXGFRw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=KpTOr1s2T9pVXUAps8LMiwudORe4lrZMuXaR9JW4KFPzt4iGyjW6tVupQF+HW78oMdgne9w6lxa6y8aUv+tgV9CSpdDE9vSbRO8wGzwZ0ISoEK6Tbid7PN1gv5QSmu7TTsVaPamQE+ddf9Sz//3qD7P3sV3fAp94rcy1f6jjqNc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PATA-disk named sda
Date: Fri, 6 Jul 2007 20:09:08 +0200
User-Agent: KMail/1.9.6
Cc: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       linux-kernel@vger.kernel.org
References: <fa.VMMtK2yPXE5gkxuIC8MWb1aPBiQ@ifi.uio.no> <fa.DRDWDh+VAXx84D/6XHgY6h2wB+E@ifi.uio.no> <468E5420.7090605@shaw.ca>
In-Reply-To: <468E5420.7090605@shaw.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707062009.08635.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 06 July 2007, Robert Hancock wrote:
> Christoph Pleger wrote:
> > Hello,
> > 
> >>> In the newest Ubuntu Release, my PATA-disk is called sda instead of
> >>> hda. Is that a general feature in newer kernel versions or is it a
> >>> special feature in Ubuntu?
> >> General. SATA and now PATA drives map onto the /dev/sd range as do
> >> SCSI, USB etc
> > 
> > It seems to be not that simple, at least not if both the old IDE
> > interface and the new libata interface are enabled as modules: In my
> > Ubuntu system, I created two kernel packages (from the same kernel
> > source and with the same configuration) and installed them. Afterwards,
> > I re-created the initial ramdisks, one with the Ubuntu feisty utilities
> > and one with Debian etch utilities. So, I had the same kernel with
> > different ramdisks. With the Ubuntu ramdisk, my harddrive was named sda,
> > but with the Debian ramdisk, it was named hda.
> > 
> > So, the name of the drive can depend on something which happens in the
> > ramdisk environment. Does anybody know what that is? And is there a
> > kernel command line parameter which restores the old behaviour?
> > 
> > And what about hdparm (setting 32bit I/O and multi-sector mode)? Suren
> > wrote that 32bit I/O makes no sense when using DMA. Maybe that's right,
> > but it does not correspond with my experiences. At least, I have the
> > "feeling" that my IDE disks work much faster since I enabled 32bit
> > support (DMA already was on before).
> 
> No, it has absolutely no effect in DMA mode.
> 
> Currently the DMA, multi-sector mode, etc. are not controllable with 
> hdparm with libata. libata is designed to use the fastest settings 
> possible by default. In a lot of cases this messing with hdparm was only 
> needed because of stupidity with the old IDE code (like DMA not being 
> automatically enabled if the low-level driver was built modular).

AFAIR there has never been such issue with IDE subsystem.

In modular case you just have to remember to _not_ load generic
IDE host driver if you don't need it, same with libata PATA.

Bart
