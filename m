Return-Path: <linux-kernel-owner+w=401wt.eu-S935010AbXLPRd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010AbXLPRd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 12:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXLPRdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 12:33:17 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:24922 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbXLPRdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 12:33:16 -0500
X-Trace: 642508500-mk-filter-4.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.89.91
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAFfwZEdRAVlb/2dsb2JhbACBV6Y7
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org, axboe@kernel.dk
In-Reply-To: <20071216095019.GA12184@linux-sh.org>
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
	 <20071216095019.GA12184@linux-sh.org>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 17:32:51 +0000
Message-Id: <1197826371.6254.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-16 at 18:50 +0900, Paul Mundt wrote:
> Ok, I don't know anything about the CD-ROM layer, so I've just commented
> on the general and SH-specific stuff. Hopefully someone with a clue
> in this area (ie, not me) can offer input on the rest of the bits.
> 

> > +static char gdrom_execute_diagnostic(void)
> > +{
> > +	int count;
> > +	/* Restart the GDROM */
> > +	ctrl_outl(0x1fffff, GDROM_RESET_REG);
> > +	for (count = 0xa0000000; count < 0xa0200000; count += 4)
> > +		ctrl_inl(count);
> 
> Er? This ranged dummy reading of the P2 space needs some explanation. The
> GD-ROM isn't even mapped in to this space, so this seems like a hack to
> either work around a timing issue or a write ordering problem.
> 

I'll confess to not knowing what it's up to here either, other than it
looks like a mechanism to cause a G1 bus reset. This is a progressive
read of the Boot ROM area and that is all under G1 control (as is the GD
Rom obviously)

Replacing it with a simple delay of any length or, say, a read of one
word and then a delay, doesn't work.




