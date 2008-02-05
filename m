Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbYBEKIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbYBEKIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYBEKHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:07:49 -0500
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:21925 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756766AbYBEKHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:07:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rcGsi6l9ko303gjvlWeVsxRQooASsYgZyIXwSdIw4IgSEvDKaAGpekAZPW1jphh5A4uZWHBWbXAdUvsIVqvJ30yoQ7g2r/Ro46gcJlZxSpwmAMOBusa+ZVykAiUmAFBsOiBKodHko/bX8OuH3WLYTIsGN05SWc5Hd0zjdhyWmoY=  ;
X-YMail-OSG: JGK4zC8VM1mlDUQ07Y8lAv9Om6RAP59MP6bdWpIO0roSB_JVftiPBggrqeHt5fMDXBfHNRDDGA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: [PATCH] at91_mci:  use generic GPIO calls
Date: Tue, 5 Feb 2008 02:07:44 -0800
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>
References: <200802011901.27532.david-b@pacbell.net> <47A74790.50207@atmel.com> <200802051053.33105.marc.pignat@hevs.ch>
In-Reply-To: <200802051053.33105.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802050207.44721.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008, Marc Pignat wrote:
> Hi all!
> 
> >  /*
> > @@ -946,9 +986,10 @@ static int __exit at91_mci_remove(struct
> >  	host = mmc_priv(mmc);
> >  
> >  	if (host->board->det_pin) {
> > +		if (device_can_wakeup(&pdev->dev))
> > +			free_irq(gpio_to_irq(host->board->det_pin), host);
>
> Seems strange to use device_can_wakeup(&pdev->dev) as
> have_we_requested_this_irq(gpio_to_irq(host->board->det_pin))... but seems to
> work.

Yeah ... it only works because the device_init_wakeup() is
done in the driver (sigh) instead of the device setup code.
Now that's only done if that IRQ was correctly requested,
so that bit does double duty.

Previously the driver always freeed that IRQ, even if it
hadn't actually managed to request it ... ;)


