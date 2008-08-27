Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYH0RxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYH0RxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYH0Rws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:52:48 -0400
Received: from mail2.shareable.org ([80.68.89.115]:59625 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbYH0Rwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:52:47 -0400
Date: Wed, 27 Aug 2008 18:51:53 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Message-ID: <20080827175152.GA27491@shareable.org>
References: <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com> <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org> <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com> <1219827609.30209.29.camel@spike.firmix.at> <f7848160808270556q54c36270ye6a465d2ca123cc@mail.gmail.com> <1219843032.30209.51.camel@spike.firmix.at> <20080827154805.GA25387@shareable.org> <1219855121.30209.112.camel@spike.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219855121.30209.112.camel@spike.firmix.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:
> > 32MB no-MMU ARM boards which people run new things and attach new
> > devices to rather often - without making new hardware.  Volume's too
> > low per individual application to get new hardware designed and made.
> 
> Yes, you may have several products on the same hardware with somewhat
> differing requirements (or not). But that is much less than a general
> purpose system IMHO.

It is, but the idea that small embedded systems go through a 'all
components are known, drivers are known, test and if it passes it's
shippable' does not always apply.

> > I'm seriously thinking of forwarding porting the 4 year old firmware
> > from 2.4.26 to 2.6.current, just to get new drivers and capabilities.
> 
> That sounds reasonable (and I never meant maintaining the old system
> infinitely.

Sounds reasonable, but it's vetoed for anticipated time and cost,
compared with backporting on demand.  Fair enough, since 2.6.current
doesn't support ARM no-MMU last I heard ('soon'?).

On the other hand, the 2.6 anti-fragmentation patches, including
latest SLUB stuff, ironically meant to help big machines, sound really
appealing for my current problem and totally unrealistic to
backport...

> ACK. We avoid MMU-less hardware too - especially since there is enough
> hardware with a MMU around.

I can't emphasise enough how much difference MMU makes to Linux userspace.

It's practically: MMU = standard Linux (with less RAM), have everything.
No-MMU = lots of familiar 'Linux' things not available or break.

-- Jamie
