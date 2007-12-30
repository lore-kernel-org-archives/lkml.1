Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbXL3Thq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbXL3Thq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 14:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbXL3Thh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 14:37:37 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:42601 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbXL3Thg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 14:37:36 -0500
Message-ID: <4777F297.9070207@keyaccess.nl>
Date: Sun, 30 Dec 2007 20:33:43 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl>	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>	<20071230144700.78f4605c@the-village.bc.nu>	<20071230152835.GX16946@elte.hu>	<20071230153818.1a554a7e@the-village.bc.nu>	<20071230160132.GA14311@elte.hu>	<20071230164828.039916c8@the-village.bc.nu>	<4777E010.7030703@keyaccess.nl> <20071230183927.5a5a3c42@the-village.bc.nu>
In-Reply-To: <20071230183927.5a5a3c42@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-12-07 19:39, Alan Cox wrote:

> On Sun, 30 Dec 2007 19:14:40 +0100
> Rene Herman <rene.herman@keyaccess.nl> wrote:

>> I'm by the way looking at drivers/net/wd.c which my 386 uses for its dual 
>> mode NE2000/WD8013 clone ISA NIC and while it specifically needs no delay at 
>> all it seems, the mixed use of out and outb_p seems to suggest that someone 
>> once thought about that. Would you advice sticking in a udelay(2) manually 
>> there?
> 
> I would need to dig out the documentation and NE2000 reference code if I
> even still have them. From memory NE2K needs them but I don't know
> offhand if the WD80x3 devices do, or if only some of them do. It'll also
> depend on the port - the DPRAM is different to the 8390.
> 
> Don Becker wrote the drivers and at the time he tuned them carefully for
> performance so I would expect delays to be the ones needed

This NIC (a Networth UTP16B) has a National Semiconductor DP83905 AT/LANTIC 
for which I'm reading the software developers guide now. It doesn't seem to 
list specific delays...

I also just now dug up a "WDC (C) 1987" WD8003EBT and a "Novell, Inc (C) 
1990" NE1000, both 8-bit ISA NICs and the ownership of which, I would 
suggest, makes me a really cool person. Both are coax and a little clumsy to 
test but that 1987 one is probably going to be close to the oldest type around.

I've been testing with the 386's own 2.2.26 kernel upto now but I'll try and 
compile a 2.6 system on there with uclibc and busybox or some such and test 
more.

Rene.
