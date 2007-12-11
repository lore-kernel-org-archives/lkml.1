Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbXLKNup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbXLKNup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXLKNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:50:36 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:37184 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbXLKNuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:50:35 -0500
Message-ID: <475E95A3.3070801@davidnewall.com>
Date: Wed, 12 Dec 2007 00:20:27 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Paul Rolland <rol@as2917.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl>
In-Reply-To: <475E8D91.20201@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> This particular discussion isn't about anything in general but solely 
> about the delay an outb_p gives you on x86 since what is under 
> discussion is not using an output to port 0x80 on that platform to 
> generate it.

That could be true if outb_p were used only in architecture dependent 
code, but it's not.  It's used in drivers that are supposed to run on 
all sorts of platforms.  Why does a megaraid controller need delays on 
i386 but not on Sparc, PowerPC, Alpha and others?  Is it buggy on most 
platforms, or just unnecessarily slow on Intel?

>> is needed, wouldn't you use a real delay; one that says how long it
>> should be?
> Thinking that _p gives a pause is perhaps too PC-centric. Why, if a delay
>
> Because any possible outb_p delay should be synced to the bus-clock, 
> not to any wall-clock.

You misunderstand.  A delay can be counted in bus cycles.

> In the real world, driver authors aren't perfect and will have used 
> outb_p as a wall-clock delay which they have gotten away with since 
> it's a nicely specified delay in terms of the ISA/LPC clock and the 
> ISA/LPC clock being fairly (old) to very (new) constant.

It's most commonly a zero delay.  Only in the minority of architectures 
is it otherwise.  If a delay is needed, then put one in, but don't put 
in a paper promise that's more likely to be ignored than observed.

Plenty of doubt has been expressed as to whether _p is widely used 
without need.  Not surprising since it has such a vague specific 
meaning.  One could say, Linux on i386 is liberally sprinkled with 
needless delays.  I suppose it has the advantage that Microsoft will be 
hard pressed to catch up when finally we remove them. :-)

I really prefer accurate code, but I'm also pragmatic and realise that 
it's far too much work to fix this any time soon.  But if it were to be 
fixed, then perhaps _p would take an additional parameter, measured in 
cycles of delay.
