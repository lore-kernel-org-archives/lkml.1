Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbZFZQzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbZFZQzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZFZQyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:54:54 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:56028 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750839AbZFZQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:54:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=S/OUmxb895ugjEPKc78Rcc8IiWVH6Gp37dbXjva1/BnERy1Dekkb7unqbju8ni6Q0wAbWKMf75kA5KqR3r5/JtQWWZ4v7Yzf2PXj61JY8JLjB0R54UHcp0O6bH9KZ2J5;
Date: Fri, 26 Jun 2009 09:54:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626095454.6f993a9c@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.00.0906261827490.2767@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com>
	<20090626071955.GG14078@elte.hu>
	<20090626101310.4110a290@lxorguk.ukuu.org.uk>
	<20090626093859.GA12571@elte.hu>
	<20090626111603.758ec7fb@lxorguk.ukuu.org.uk>
	<20090626110429.GB12446@elte.hu>
	<20090626125653.5e30bae4@lxorguk.ukuu.org.uk>
	<20090626122254.GA9959@elte.hu>
	<20090626133318.5b8de81b@lxorguk.ukuu.org.uk>
	<20090626142937.GA19477@elte.hu>
	<alpine.LFD.2.00.0906261827490.2767@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 18:32:42 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 26 Jun 2009, Ingo Molnar wrote:
> > [ Although it is beyond me why ABP was done - why wasnt HPET good
> >   enough? HPET can do per CPU clockevents too and it's just as 
> >   off-chip (and hence fundamentally slow) as ABP. ]
> 
> Welcome to the wonderful world of embedded systems. Just have a peek
> into arch/[arm/powerpc/mips] to see what's coming up to us with full
> force. I would not be surprised when we see an x86 system sharing the
> device driver for i2c or whatever with an ARM SoC in the foreseable
> future.

Ha, yeah I was just going to say "think embedded".  ABP is a much
simpler spec and programming interface than HPET, and since we were
designing new custom silicon, it made sense to just do the simple
thing, rather than butchering an existing spec, then making a partial
HPET that looks like ABP anyway and forcing any future HPET updates to
conform to the new standard (very similar reasoning to the ACPI vs SFI
discussion btw).  Hopefully the technologies we've come up with for
MRST will be flexible enough to be used in future platforms as well;
we'll see.

-- 
Jesse Barnes, Intel Open Source Technology Center
