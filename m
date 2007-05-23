Return-Path: <linux-kernel-owner+w=401wt.eu-S1761060AbXEWUyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbXEWUyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXEWUyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:54:10 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:53922 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbXEWUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:54:09 -0400
Date: Wed, 23 May 2007 22:54:07 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] local_softirq_pending storm
In-Reply-To: <20070521200428.GA9855@osiris.ibm.com>
Message-ID: <Pine.LNX.4.64.0705232243230.2104@artax.karlin.mff.cuni.cz>
References: <200705091942.22920.kernel@prachanda.hub> <200705171211.23350.kernel@prachanda.hub>
 <1179493277.12981.69.camel@chaos> <200705191525.28400.kernel@prachanda.hub>
 <1179601868.12981.127.camel@chaos> <20070520101800.GC9892@osiris.ibm.com>
 <1179669141.21827.22.camel@chaos> <20070520183658.GA13262@osiris.ibm.com>
 <20070520191800.GA14225@osiris.ibm.com> <1179689389.6570.1.camel@chaos>
 <20070521200428.GA9855@osiris.ibm.com>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Heiko Carstens wrote:

> On Sun, May 20, 2007 at 09:29:49PM +0200, Thomas Gleixner wrote:
>> On Sun, 2007-05-20 at 21:18 +0200, Heiko Carstens wrote:
>>>>> Hmm, that's a different problem than the 0x22 which shows up on
>>>>> hyperthreading enabled P4 systems. Are you using plip ?
>>>>
>>>> No, after all it turned out that is caused by an IBM internal module.
>>>> Just ignore me, sorry for the noise :)
>>>
>>> Just in case you're interested: I just looked into it and it turned
>>> out that this module was calling netif_rx() from process context,
>>> just like plip. Changing it to netif_rx_ni() fixes it.
>>
>> Thanks, that's a good pointer. You should have cc'ed Dave Miller and the
>> guy who found this plip thingy. Care to resend ?
>
> No problem. Here we go, even though I doubt that netif_rx_ni() is what
> people want for plip. Dunno...

netif_rx_ni calls softirq synchronously, am I right? That would probably 
hurt plip. I can try it if someone will be interested in it, but I doubt 
it is good solution for any network interfaces except tun.

BTW. does in_interrupt() have high cost on some high-performance 
architectures? Would it be possible to just add if (!in_interrupt()) 
wakeup_softirqd(); to netif_rx()?

Mikulas
