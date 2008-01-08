Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYAHNIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYAHNIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 08:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYAHNIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 08:08:34 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:62880 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbYAHNId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 08:08:33 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ynNUNgNFuV6aiZfastvP8
Message-ID: <478375AA.3090306@reed.com>
Date: Tue, 08 Jan 2008 08:07:54 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Rene Herman <rene.herman@keyaccess.nl>, "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it> <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it> <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it> <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it> <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it> <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it> <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com> <alpine.LSU.0.999.0801072226060.16143@be1.lrz> <4782A355.1070207@zytor.com> <alpine.LSU.0.999.0801072316440.16143@be1.lrz> <4782AED5.1060406@keyaccess.nl> <4782B4B9.2020608@zytor.com> <4782B515.3010008@keyaccess.nl> <alpine.LSU.0.999.0801081333530.12636@be1.lrz>
In-Reply-To: <alpine.LSU.0.999.0801081333530.12636@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last time I heard of a 12 MHz bus in a PC system was in the days of 
the PC-AT, when some clone makers sped up their buses (pre PCI!!!) in an 
attempt to allow adapter card *memory* to run at the 12 MHz speed.

This caused so many industry-wide problems with adapter cards that 
couldn't be installed in certain machines and still run reliably that 
the industry learned a lesson.  That doesn't mean that LPCs don't run at 
12 MHz, but if they do, they don't have old 8 bit punky cards plugged 
into them for lots of practical reasons.  (I have whole drawers full of 
such old cards, trying to figure out an environmentally responsible way 
to get rid of them - even third world countries would be fools to make 
machiens with them).

I can't believe that we are not supporting today's machines correctly 
because we are still trying to be compatible with a few (at most a 
hundre thousand were manufactured!  Much less still functioning or 
running Linux) machines.

Now I understand that PC/104 machines and other things are very non PC 
compatible, but are x86 processor architectures.  Do they even run x86 
under 2.6.24?

Perhaps the rational solution here is to declare x86 the architecture 
for "relics" and develop a merged architecture called "modern machines" 
to include only those PCs that have been made to work since, say, the 
release of (cough) WIndows 2000?

Bodo Eggert wrote:
> On Tue, 8 Jan 2008, Rene Herman wrote:
>   
>> On 08-01-08 00:24, H. Peter Anvin wrote:
>>     
>>> Rene Herman wrote:
>>>       
>
>   
>>>> Is this only about the ones then left for things like legacy PIC and PIT?
>>>> Does anyone care about just sticking in a udelay(2) (or 1) there as a
>>>> replacement and call it a day?
>>>>
>>>>         
>>> PIT is problematic because the PIT may be necessary for udelay setup.
>>>       
>> Yes, can initialise loops_per_jiffy conservatively. Just didn't quite get why
>> you guys are talking about an ISA bus speed parameter.
>>     
>
> If the ISA bus is below 8 MHz, we might need a longer delay. If we default
> to the longer delay, the delay will be too long for more than 99,99 % of 
> all systems, not counting i586+. Especially if the driver is fine-tuned to 
> give maximum throughput, this may be bad.
>
> OTOH, the DOS drivers I heared about use delays and would break on 
> underclocked ISA busses if the n * ISA_HZ delay was needed. Maybe
> somebody having a configurable ISA bus speed and some problematic
> chips can test it ...
>
>   
