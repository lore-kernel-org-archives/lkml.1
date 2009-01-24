Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbZAXRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbZAXRqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 12:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZAXRqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 12:46:07 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:48635 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZAXRqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 12:46:06 -0500
Date: Sat, 24 Jan 2009 18:46:02 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: yi li <liyi.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] MMC/SD: SDHC card capacity not correct
Message-ID: <20090124184602.5880fed9@mjolnir.drzeus.cx>
In-Reply-To: <a0e7fce50901130000u36528132jc3a9ecbd9084b043@mail.gmail.com>
References: <a0e7fce50901081953h7ae152a7y557794c07fbb843b@mail.gmail.com>
	<20090112162044.2bc12cef@mjolnir.drzeus.cx>
	<a0e7fce50901130000u36528132jc3a9ecbd9084b043@mail.gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 16:00:21 +0800
yi li <liyi.dev@gmail.com> wrote:

> 2. Fix like this:
> --- card/block.c	2009-01-13 15:56:05.000000000 +0800
> +++ card/block.c.new	2009-01-13 15:53:45.000000000 +0800
> @@ -514,7 +514,7 @@ static int mmc_blk_probe(struct mmc_card
>  	if (err)
>  		goto out;
> 
> -	string_get_size(get_capacity(md->disk) << 9, STRING_UNITS_2,
> +	string_get_size((u64)get_capacity(md->disk) << 9, STRING_UNITS_2,
>  			cap_str, sizeof(cap_str));
>  	printk(KERN_INFO "%s: %s %s %s %s\n",
>  		md->disk->disk_name, mmc_card_id(card), mmc_card_name(card),
> 
> I prefer the second fix, what do you think?
> 

Agreed. Send me a proper patch with a S-o-b and all that. :)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
