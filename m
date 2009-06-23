Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbZFWICj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbZFWICj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZFWIC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:02:28 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52927 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZFWICZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=sLkQEUVXGqkY0C94sJRH2JdwFGarB1CltNpEymUmLTxnfrYQkbOmj7sENx+dkRFJdY
         028ZvgwvyRqZGOw8TTJ3NoRMHB09PJSF4ia06tLX/Fc8wBJy5NnWLpltBuA42UYOtTVg
         6+8XzmzNdv1HEJNQ/NNnvH/CASZuqH1757qEQ=
Date: Tue, 23 Jun 2009 10:02:23 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Frans Pop <elendil@planet.nl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cd: Improve "weird block size" error message
Message-ID: <20090623080223.GA19253@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Frans Pop <elendil@planet.nl>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906211446.38598.elendil@planet.nl> <200906222101.38586.elendil@planet.nl> <200906222335.06700.bzolnier@gmail.com> <200906230951.24615.elendil@planet.nl> <20090623075733.GA14790@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090623075733.GA14790@liondog.tnic>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:57:33AM +0200, Borislav Petkov wrote:
> On Tue, Jun 23, 2009 at 09:51:23AM +0200, Frans Pop wrote:
> 
> [..]
> 
> > ---
> > From: Frans Pop <elendil@planet.nl>
> > Subject: ide-cd: Improve "weird block size" error message
> > 
> > Currently the error gets repeated too frequently, for example
> > each time HAL polls the device when a disc is present. Avoid that
> > by using printk_once instead of printk.
> > Also join the error and corrective action messages into a single line.
> > 
> > Signed-off-by: Frans Pop <elendil@planet.nl>
> > Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > 
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index 4a19686..7ec6996 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -886,10 +886,9 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
> >  	case 4096:
> >  		break;
> >  	default:
> > -		printk(KERN_ERR PFX "%s: weird block size %u\n",
> > +		printk_once(KERN_ERR PFX "%s: weird block size %u; "
> > +				"setting default block size to 2048\n",
> >  				drive->name, blocklen);
> > -		printk(KERN_ERR PFX "%s: default to 2kb block size\n",
> > -				drive->name);
>

Ah, nevermind! Hadn't had a coffee yet, sorry :).

Acked-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
