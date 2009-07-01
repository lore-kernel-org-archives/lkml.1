Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZGARZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZGARZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZGARZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:25:02 -0400
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:46964 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752524AbZGARZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:25:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BlpfvTQzO/PAYU3jYEiddm2L8alKV2IYhfjhckQIsEHYTAufr3Jf6gKc46blKrFqOI+7Ym8ipMChlnCDg1wdlxTjFiB9uyMpccbz0UxQrwc3CexZHWHBMdbO99evbWpM;
Date: Wed, 1 Jul 2009 10:25:00 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090701102500.696962db@jbarnes-g45>
In-Reply-To: <20090630063513.GJ1351@ucw.cz>
References: <20090626101310.4110a290@lxorguk.ukuu.org.uk>
	<20090626093859.GA12571@elte.hu>
	<20090626111603.758ec7fb@lxorguk.ukuu.org.uk>
	<20090626110429.GB12446@elte.hu>
	<20090626125653.5e30bae4@lxorguk.ukuu.org.uk>
	<20090626122254.GA9959@elte.hu>
	<20090626133318.5b8de81b@lxorguk.ukuu.org.uk>
	<20090626142937.GA19477@elte.hu>
	<alpine.LFD.2.00.0906261827490.2767@localhost.localdomain>
	<20090626095454.6f993a9c@jbarnes-g45>
	<20090630063513.GJ1351@ucw.cz>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 08:35:13 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2009-06-26 09:54:54, Jesse Barnes wrote:
> > On Fri, 26 Jun 2009 18:32:42 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Fri, 26 Jun 2009, Ingo Molnar wrote:
> > > > [ Although it is beyond me why ABP was done - why wasnt HPET
> > > > good enough? HPET can do per CPU clockevents too and it's just
> > > > as off-chip (and hence fundamentally slow) as ABP. ]
> > > 
> > > Welcome to the wonderful world of embedded systems. Just have a
> > > peek into arch/[arm/powerpc/mips] to see what's coming up to us
> > > with full force. I would not be surprised when we see an x86
> > > system sharing the device driver for i2c or whatever with an ARM
> > > SoC in the foreseable future.
> > 
> > Ha, yeah I was just going to say "think embedded".  ABP is a much
> > simpler spec and programming interface than HPET, and since we were
> > designing new custom silicon, it made sense to just do the simple
> > thing, rather than butchering an existing spec, then making a
> > partial HPET that looks like ABP anyway and forcing any future HPET
> > updates to conform to the new standard (very similar reasoning to
> > the ACPI vs SFI discussion btw).  Hopefully the technologies we've
> > come up with for
> 
> Very similary wrong, I'd say :-(. While you could have created
> hpet-lite, where hpet-lite driver would work on hpet system, you went
> and created something new.
> 
> And yes, SFI is similar disaster, you should just define subset of
> acpi ('acpi-lite').
> 
> In the end, you are willing to use silicon for compatibility (arm
>  instruction set needs less transistors, right?) and wasting millions
>  of transistors, then try to save thousands with non-compatible
>  devices :-(.

You didn't address the essence of either argument; butchering an
existing spec and placing an extra burden on all future implementations
is a high price to pay, both in terms of complexity and cost.

But really these are moot points; this is how the platform works.  I'd
like to see Linux run on it "out of the box" which means integrating
support for these features in a maintainable way.  Hopefully no one
disagrees with that; after all Linux runs on much uglier platforms than
this.

-- 
Jesse Barnes, Intel Open Source Technology Center
