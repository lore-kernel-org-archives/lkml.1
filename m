Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbXLKOQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbXLKOQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXLKOQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:16:04 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:48622 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbXLKOQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:16:03 -0500
Message-ID: <475E9B3A.7050403@keyaccess.nl>
Date: Tue, 11 Dec 2007 15:14:18 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
CC: Paul Rolland <rol@as2917.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com>
In-Reply-To: <475E95A3.3070801@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 14:50, David Newall wrote:

> Rene Herman wrote:

>> This particular discussion isn't about anything in general but solely 
>> about the delay an outb_p gives you on x86 since what is under 
>> discussion is not using an output to port 0x80 on that platform to 
>> generate it.
> 
> That could be true if outb_p were used only in architecture dependent

It not only could be, it _is_ true. Not using an output to port 0x80 is what 
this discussion is about.

> code, but it's not.  It's used in drivers that are supposed to run on 
> all sorts of platforms.  Why does a megaraid controller need delays on 
> i386 but not on Sparc, PowerPC, Alpha and others?  Is it buggy on most 
> platforms, or just unnecessarily slow on Intel?

The latter probably and I don't bleedin' well care. In a discussion about 
removing the out to 0x80 the only thing that is relevant is what it should 
be replaced with. Usually, "nothing" will do but generally, udelay(1) will.

>>> is needed, wouldn't you use a real delay; one that says how long it
>>> should be?
>> Thinking that _p gives a pause is perhaps too PC-centric. Why, if a delay
>>
>> Because any possible outb_p delay should be synced to the bus-clock, 
>> not to any wall-clock.
> 
> You misunderstand.  A delay can be counted in bus cycles.

No damnit, you misunderstand. I'm saying that an outb_p _should_ be defined 
in terms of the bus clock since if you want a wall-clock delay you should be 
using just that.

The _hardware_ is synced to the bus clock and therefore, having a delay 
available that is synced to the bus clock as well makes some sense. And 
again again again again not withstanding that, a udelay will still be an 
okay replacement in practice.

Rene.
