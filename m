Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbXLDVyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbXLDVyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXLDVyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:54:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:64884 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbXLDVyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:54:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uqIrfqfdQbU0xjHnN2i8sNsXVdw5vZRnWO2MpYB35p1Ho2W0qCe6xNkpx2txHbAVgIbMvyZZ9dlZN4yo3BxwdvvgdxePhBuuUhHQUSFwXZbv6HlaYSVmbQREhEpEYdr9/6X06EFPyLWn04Yr2W9OGyvNgQgWfxea1lqMQbE5S/4=
Message-ID: <6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
Date: Tue, 4 Dec 2007 13:54:21 -0800
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: solid state drive access and context switching
Cc: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071204203536.2bf6d025@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47548BF4.3010907@nortel.com>
	 <20071203230629.725f4c7a@the-village.bc.nu>
	 <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
	 <20071204203536.2bf6d025@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > microseconds level and an order of magnitude higher bandwidth than
> > SATA.  Is that fast enough to warrant this more synchronous IO?
>
> See the mtd layer.

Right.  The trend is to hide the nastiness of NAND technology changes
behind controllers.  In general I think this is a good thing.
Basically the changes in ECC and reliability change very rapidly in
this technology.  Having custom controller hardware to handle this is
faster than handling it in software and makes for a nice modular
interface.  We don't rewrite our SATA drivers and filesystem
everything the magnetic media switches to a new recording scheme, we
just plug it in.  SSD's are going to be like that even if they aren't
SATA. However, the MTD layer is more about managing the chips
themselves, which is what the controllers are for.

Maybe I'm missing something but I don't see it.  We want a block
interface for these devices, we just need a faster slimmer interface.
Maybe a new mtdblock interface that doesn't do erase would be the
place for?

> > BTW - This trend toward faster, lower latency busses is marching
> > forward.  2 examples; the ioDrive from Fusion IO, Micron's RAM-module
> > like SSD concept.
>
> Very much so but we can do quite a bit in 10,000 processor cycles ...
>
> Alan
>
