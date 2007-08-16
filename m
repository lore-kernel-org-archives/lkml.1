Return-Path: <linux-kernel-owner+w=401wt.eu-S934096AbXHPQ1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbXHPQ1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765442AbXHPQ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:27:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:12784 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765810AbXHPQ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Td8U3tds58+S5amC2Zp6H2d4yBGvyQCP8mOx106rY0uWwFISm9bv1aJGP+ObJJ1LuWSfh0Nev3vqTbS4R5MXToWY++puFNY+frs1Np2yEuz3+jBijD0RlR+5v0OGviyFpV0G2P6aet+QuxL2dJ4DxAZPbrXMyKjyOsmBAGCD3D8=
Message-ID: <8bd0f97a0708160927s625fd5ax84cd6d12a693d9ad@mail.gmail.com>
Date: Thu, 16 Aug 2007 12:27:05 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH take #5] [libata] libata driver for bf548 on chip ATAPI controller.
Cc: "Sonic Zhang" <sonic.adi@gmail.com>,
       "Linux IDE" <linux-ide@vger.kernel.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Bryan Wu" <bryan.wu@analog.com>
In-Reply-To: <46C3F6FB.2070909@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187169256.31383.3.camel@sevens.analog.com>
	 <46C3F6FB.2070909@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/07, Jeff Garzik <jeff@garzik.org> wrote:
> Sonic Zhang wrote:
> > +static void bfin_set_piomode(struct ata_port *ap, struct ata_device *adev)
> > +{
> > +     int mode = adev->pio_mode - XFER_PIO_0;
> > +     unsigned long base = (unsigned long)ap->ioaddr.ctl_addr;
>
>
> (added Bryan Wu to CC)
>
> Someone needs to need fix the bfin architecture:  the addresses on the
> bfin_read/bfin_write functions should be 'void __iomem *' not unsigned long.

there are no address pointers anymore, so there is nothing to cast ...
the bfin_read/bfin_write macros are done in sexy asm:
#define bfin_write8(addr,val) __asm__ __volatile__("b[%0] = %1;" ::
"a"(addr), "d"(val))
or i'm misunderstanding what you mean ...

where do you see (unsigned long) ?
-mike
