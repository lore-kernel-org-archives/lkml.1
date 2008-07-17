Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbYGQLG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbYGQLG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbYGQLGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:06:19 -0400
Received: from www.tglx.de ([62.245.132.106]:50829 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbYGQLGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:06:18 -0400
Date: Thu, 17 Jul 2008 13:05:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard <tuxbox.guru@gmail.com>
cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
In-Reply-To: <487F309D.20709@gmail.com>
Message-ID: <alpine.LFD.1.10.0807171255320.4316@apollo.tec.linutronix.de>
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807171232.46542.trenn@suse.de> <487F309D.20709@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Richard wrote:
> > north-bridge: nvidia c51mv
> > south-bridge: nvidia mcp51m
> > 
> > Also both are MSI laptops:
> >   - MSI-M670, modell MS-1632
> >   - MSI S430x
> > (This could also be a chipset or even an MSI specific BIOS bug?
> > Richard could you compare with your HW, pls if still possible).
> > 
> > Some more info:
> >   - things break entering C2 or deeper
> >   - noapictimer workaround helps to come a bit further, but results in sever
> >     other errors, disk(dma error), keyboad, mouse etc., also see:

Hmm, I don't see how the apic timer is related to that, but it might
be a problem with the hpet.

Does "noapictimer nohz=off" work ?

> >     https://bugzilla.novell.com/show_bug.cgi?id=396220#c13
> >   - "nohz=off" works (tested on 2.6.25.4-8-pae and 2.6.22.17-0.1-default
> > SUSE kernels)
> >   - processor.max_cstate=1 works

Why does it work with 2.6.24 on kubuntu 8.04 ? 

How does a 2.6.24/25/26 vanilla kernel behave on those systems ?

> > 00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
> 
> Here is a dump from lspci.... looks completely different :-P and here i was
> blaming ATI :-)
> 
> 00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge

Oh, that's a different beast, but it might be also a problem with the
timer interrupt routing.

Thanks,

	tglx
