Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbYB2Qua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbYB2Qua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760893AbYB2QuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:50:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:61982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760885AbYB2QuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=dnAol9osA/M5eiTjNmxYoMY/eNNp8QTwRK4SJakq9CCHb3iCyChmspGtAB8Vfwlr0iR2bzF4ujyCoFzrz37yiHZ30CyVb3Kr2H/VtqojKZrjWQf1US+UnfsI1MdaaQ3I3mwwm0oLCkzHxRC5hGK6hn/mJWse90zmjhLYZnQOrTI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: devres and requesting resources
Date: Fri, 29 Feb 2008 18:04:09 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <47C75392.3020606@garzik.org> <47C7FA8B.7040306@gmail.com> <20080229140106.41ccc843@core>
In-Reply-To: <20080229140106.41ccc843@core>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802291804.09412.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 February 2008, Alan Cox wrote:
> > controller like ICH AHCIs.  ata_generic or ide generic might attach to a
> > controller which is already being driven by ahci under certain
> > configurations.
> 
> ata_generic will not nor ata_legacy both are much too smart for that. The
> legacy old IDE driver might but that probably isn't going to be fixed by
> devres and is trivial to fix in that driver (just steal the code from
> pata_legacy).

Yep, nice trick.

Since it is your idea/code could you please also fix ide_generic? :)

> > have different requirements can just open code pci_request_regions() and
> > pcim_iomap().  pcim_request_regions() should provide sensible default
> > behavior for common cases.
> 
> Which is arguably the current behaviour. Changing the behaviour and not
> the name is a really bad idea and will cause problems in future so don't
> do that.
> >
> > I think the best solution is to allow duplicate request regions for
> > managed devices which is okay as we know we're holding the resource and
> > let drivers which need to reserve all regions call pci_request_regions()
> > before calling pcim_request_regions().

This will work until code outside libata (i.e. IDE) starts using devres...

[ Incidentally, just yesterday I finished moving resource management handling
  to host drivers so it might as well happen. ]

> How about
> 
> 	pcim_request_all_regions()
> 
> for the behaviour Jeff wants, simple, direct, differently named and
> obvious what it does.

Seconded.

Thanks,
Bart
