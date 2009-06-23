Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZFWIVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZFWIVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZFWIUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:20:47 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:50669 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbZFWIUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:20:45 -0400
From: Frans Pop <elendil@planet.nl>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH] ide-cd: Improve "weird block size" error message
Date: Tue, 23 Jun 2009 10:20:45 +0200
User-Agent: KMail/1.9.9
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906211446.38598.elendil@planet.nl> <200906230951.24615.elendil@planet.nl> <20090623075733.GA14790@liondog.tnic>
In-Reply-To: <20090623075733.GA14790@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231020.47054.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jun 2009 08:20:47.0463 (UTC) FILETIME=[82CCFF70:01C9F3DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Borislav Petkov wrote:
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index 4a19686..7ec6996 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -886,10 +886,9 @@ static int cdrom_read_capacity(ide_drive_t
> > *drive, unsigned long *capacity, case 4096:
> >  		break;
> >  	default:
> > -		printk(KERN_ERR PFX "%s: weird block size %u\n",
> > +		printk_once(KERN_ERR PFX "%s: weird block size %u; "
                                                          ^^^^^^^
> > +				"setting default block size to 2048\n",
> >  				drive->name, blocklen);
> > -		printk(KERN_ERR PFX "%s: default to 2kb block size\n",
> > -				drive->name);
>
> Please leave the weird block size in the printk since it sometimes
> might give insights on what is going on.

I did :-)
