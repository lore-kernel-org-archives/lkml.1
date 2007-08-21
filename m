Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbXHUG0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbXHUG0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbXHUG0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:26:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbXHUG0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:26:09 -0400
Date: Mon, 20 Aug 2007 23:25:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: David Brownell <david-b@pacbell.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <1187675488.2676.3.camel@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.999.0708202316430.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com>  <200708202102.58508.david-b@pacbell.net>
  <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org> 
 <200708202148.45575.david-b@pacbell.net> 
 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
 <1187675488.2676.3.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, Arjan van de Ven wrote:
> > 
> > So it might be much better if we instead re-introduced that kind of "DMA 
> > latency requirement", and letting different subsystems react to that as 
> > they may.
> 
> wait.... we HAVE that infrastructure .. see kernel/latency.c ...

Heh. Just shows how wellknown that interface is - it seems like it's only 
used by the ipw2100 driver and "pcm_native".

But yes, that looks like the right thing.

> and the C-state code will honor it. CPUFREQ doesn't honor it yet but
> that's easy to add.. (this assumes the ACPI BIOS informs us correctly
> about the cpu behavior, but that's the best we can do obviously unless
> you want a table inside the kernel keyed off vendor/model/stepping)

Do we actually have the latency information for these things? Especially 
since I assume a number of people use the specialized direct-hw-access 
cpufreq drivers..

I realize that we *have* "transition_latency" at the cpufreq layer, and it 
is supposed to be in ns, but I wonder how likely it is to bear any 
relationship to reality, considering that I don't think it's really used 
for anything.. (yeah, it affects the heuristics, but I don't think it has 
any _hard_ meaning, so I'd worry that it's not necessarily something that 
people have tried to make accurate).

But I dunno.

		Linus
