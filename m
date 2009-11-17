Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZKQTgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZKQTgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 14:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZKQTgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 14:36:39 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:33582 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZKQTgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 14:36:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=vL4XH+jR5+izHZqpzQQIX4v7XS8aAToBt8KoQUA7OL1Uinqi7JW611cZDu0TziMwqw
         OTuwO6Eh9c1FXj4tOGc51Ld+HBIhI1pg9QJIwyOK0GbrmIFzBg8VovP120U/jkoyF8vX
         KoT8O9D7E0RGo4CvgDk4zhElTQRvNvhR7UKkI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/5] pata_sis: Implement MWDMA for the UDMA 133 capable chips
Date: Tue, 17 Nov 2009 20:33:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911171857.01805.bzolnier@gmail.com> <20091117182131.0d91fc0e@lxorguk.ukuu.org.uk>
In-Reply-To: <20091117182131.0d91fc0e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911172033.29805.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009 19:21:31 Alan Cox wrote:
> > > I'm not convinced because for the majority of drivers the libata timing
> > > interface handles it. SiS needs it just because it does things by
> > > precomputed tables. It's a one off interface.
> > 
> > Controllers based on *Intel* PIIX are in the disagreement with the above
> 
> No the PIIX is quite different. You use the matching PIO timing (which is
> a short lookup and shorter code than even a helper function call). You do
> not use the clipping instead you set bit 3 to ensure that PIO cycles
> occur at low speed but MWDMA runs at the right speed. That is usually a
> win over picking a lower mode as the PIIX can do ATAPI DMA happily.

Thank you for the detailed explanation, I certainly would still be
scratching my head over it if it wasn't for your great help.

> So the only thing you can "share" is what would be a 4 byte table.

You are of course right, I must have been confused by the old driver.

> > paragraph and having generic helper to do conversion (without a clipping)
> > would bring us a little step closer to killing a needless code duplication
> > currently present in their ->set_piomode and ->set_dmamode methods.
> > 
> > [ In case somebody wonders: no, 'old' drivers don't have such duplication
> >   and 'whoever did it didn't port it across' cause said 'whoever'-s were not
> >   into the development of the square wheels.... ]
> 
> There is no duplication in the old drivers because they don't implement
> the needed check and clipping/bit setting that I can see ;)

Seems like the whoever maintained the old driver didn't port across
this critical bugfix. :(

-- 
Bartlomiej Zolnierkiewicz
