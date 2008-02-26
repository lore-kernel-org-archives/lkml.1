Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbYBZJ0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbYBZJ0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbYBZJZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:25:43 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:43520 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761595AbYBZJZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:25:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=h2H3qU4UA7++h6ED0BzDNBg0/3XGcNja6HJ0gNkbFhlh3rlnK6v7b+BOp4PrpsedU5ZaWb8V0iLgBu+ndjsBBqRKm08gMPXKEA6X6x1qMb7ecV2ABNy6lJFOG5NiuVbSA73Af2XwTeGzAZaqdvxiVPnw//p+gwep7z4vWObQTaA=  ;
X-YMail-OSG: zeKLBEIVM1mwzZEjbFUfyP4htVOU9rsoGhXOV2IUjn_W2o4520FM3ZOL4ZSeg2vosWz3_gBOww--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [patch 2.6.25-rc2-git 2/2] atmel_tc clocksource/clockevent code
Date: Tue, 26 Feb 2008 01:25:33 -0800
User-Agent: KMail/1.9.6
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200802221728.37910.david-b@pacbell.net> <20080225175116.A2C071E564F@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080226101625.31f6954d@hskinnemoen.norway.atmel.com>
In-Reply-To: <20080226101625.31f6954d@hskinnemoen.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802260125.33713.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008, Haavard Skinnemoen wrote:
> > Another way to address that rm9200 issue would be to just rate
> > the TC clockevent source lower than the one based on the system
> > timer, so it's set up but never enabled ... and remember "t2_clk",
> > calling clk_enable() only when that clockevent device is active.
> > 
> > That would address one half of the suspend/resume equation too,
> > ensuring that clock is disabled during suspend...
> 
> Yes, we could probably do that. Which means we can just remove all the
> ifdeffery?

There'd still be the #ifdef for CONFIG_GENERIC_CLOCKEVENTS,
unless all the platforms get updated to support that.  Right
now it's a "patches available but not merged" situation.


> > The other half being:  how to clk_disable(t0_clk) during system
> > suspend?  (And t1_clk on some systems.)  There's currently no
> > clocksource.set_mode() call; evidently there's an assumption that
> > such counters cost no power, so they can always be left running.
> 
> Yes...that would be a clocksource core issue I guess. Better leave that
> for later...

My thoughts exactly.  ;)

Plus a bit of puzzlement why that didn't trigger at least a
warning during AT91 suspend testing.  There used to be warnings
there about clocks which were wrongly left enabled...

- Dave
