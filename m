Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbYLOAJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbYLOAJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 19:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYLOAJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 19:09:08 -0500
Received: from kroah.org ([198.145.64.141]:44429 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750961AbYLOAJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 19:09:06 -0500
Date: Sun, 14 Dec 2008 16:04:12 -0800
From: Greg KH <greg@kroah.com>
To: Reinhard Nissl <rnissl@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH: mvsas: increase port type detection delay to suit
	Seagate's 15k6 drive ST3450856SS 0003
Message-ID: <20081215000412.GC5622@kroah.com>
References: <49458D9C.5080906@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49458D9C.5080906@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 11:50:04PM +0100, Reinhard Nissl wrote:
> Hi Greg,
> 
> I hope you don't mind following your suggestion:
> 
> > Also, please cc: the stable developers if you want them to pay attention
> > to messages like this.

It's easier to email stable@kernel.org to make sure that I don't miss it
:)

Is the patch below in Linus's tree?  If so, do you have a git commit id?

If not, we need to wait until it is there before we can accept it into
the stable tree.

thanks,

greg k-h

> -------- Original-Nachricht --------
> Betreff: Re: PATCH: mvsas: increase port type detection delay to
> suit Seagate's 15k6 drive ST3450856SS 0003
> Datum: Fri, 12 Dec 2008 21:23:45 +0100
> Von: Reinhard Nissl <rnissl@gmx.de>
> An: linux-scsi@vger.kernel.org
> CC: Ke Wei <kewei@marvell.com>, Jeff Garzik
> <jgarzik@redhat.com>,	James Bottomley
> <James.Bottomley@hansenpartnership.com>
> Referenzen: <493BC76F.3060105@gmx.de> <49405137.9000902@gmx.de>
> 
> Hi,
> 
> I wonder why no one has dropped me a line so far. I hope you
> don't mind CCing you directly. I found your email addresses on
> mailing list entries regarding mvsas. I attach the little patch
> again for ease of use.
> 
> Reinhard Nissl schrieb:
> 
> > I increased the delay step by step until loading of mvsas
> > reliably detected the drive 200 times in sequence. A much better
> > approach would be to monitor the hardware for some flag which
> > indicates that port detection has finished, but I do not have any
> > hardware documentation.
> > 
> > BTW: patch is against
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
> > 
> > Signed-off-by: Reinhard Nissl <rnissl@gmx.de>
> 
> Bye.
> -- 
> Dipl.-Inform. (FH) Reinhard Nissl
> mailto:rnissl@gmx.de

> diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
> index 1dd70d7..23e5a87 100644
> --- a/drivers/scsi/mvsas.c
> +++ b/drivers/scsi/mvsas.c
> @@ -2959,7 +2959,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
>  
>  	/* enable auto port detection */
>  	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
> -	msleep(100);
> +	msleep(1100);
>  	/* init and reset phys */
>  	for (i = 0; i < mvi->chip->n_phy; i++) {
>  		u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]);
> 

