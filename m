Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbXL3VKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbXL3VKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXL3VKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:10:35 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:37123 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbXL3VKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:10:34 -0500
Message-ID: <47780888.9070503@keyaccess.nl>
Date: Sun, 30 Dec 2007 22:07:20 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <20071230160751.GB26221@elte.hu> <4777C6E8.7060202@keyaccess.nl> <20071230170612.GA16502@elte.hu> <20071230182937.40f2adcf@the-village.bc.nu> <20071230204650.GA26120@elte.hu>
In-Reply-To: <20071230204650.GA26120@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-12-07 21:46, Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>>> So the current plan is to go with an io_delay=udelay default in v2.6.25, 
>>> to give this a migration window, and io_delay=none in v2.6.26 [and a 
>>> complete removal of arch/x86/kernel/io_delay.c], once the _p() uses are 
>>> fixed up. This is gradual enough to notice any regressions we care about 
>>> and also makes it nicely bisectable and gradual.
>> You will break systems if you blindly go around disabling _p delays 
>> for ISA and LPC bus devices. The DEC Hinote laptops for example are 
>> well known for requiring the correct ISA and other keyboard controller 
>> delays. I don't expect anyone to test with a hinote or see it until it 
>> hits Debian or similar 'low resource' friendly devices.
> 
> well, using io_delay=udelay is not 'blindly disabling'.

On the other hand, the patch you just posted that makes io_delay=none the 
default _is_ blindly disabling. So that wasn't for consumption?

io_delay=udelay additionally blindly disables the race-hiding effect the 
outb has on SMP and that Alan is seeing so many of. Should also wait for 
more driver review.

Rene.
