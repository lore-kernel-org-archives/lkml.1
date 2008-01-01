Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbYAAXOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbYAAXOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYAAXOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:14:47 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:44204 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbYAAXOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:14:46 -0500
Message-ID: <477AC8BA.2050503@keyaccess.nl>
Date: Wed, 02 Jan 2008 00:11:54 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu>	<20071215080831.404cdb32@tux.DEF.witbe.net>	<47638C8C.2090604@gmail.com>	<476438B4.2020600@zytor.com>	<476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<4765D95C.4010404@zytor.com>	<4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu> <477AAD7B.5040405@zytor.com> <477AB204.3070904@keyaccess.nl> <477AB433.5070506@zytor.com> <477AC02A.40108@keyaccess.nl> <477AC130.3050901@zytor.com>
In-Reply-To: <477AC130.3050901@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-01-08 23:39, H. Peter Anvin wrote:

>>> Yes, we do.  It's exactly this side effect which makes this safer 
>>> than either 0x80 or 0xED -- it's a port that *guaranteed* can't be 
>>> reclaimed for other purposes without breaking MS-DOS compatibility.
>>
>> I see that with CR0.NE set (*) we indeed don't care about IGNNE#...
>>
>> However, I'm worried about this comment in arch/x86/kernel/i8259_32.c
>>
>> ===
>> /*
>>  * New motherboards sometimes make IRQ 13 be a PCI interrupt,
>>  * so allow interrupt sharing.
>>  */
>> ===
>>
>> Is it really safe to just blindly negate IRQ13 on everything out 
>> there, from regular PC through funky embedded thingies?
> 
> It's not any IRQ 13, it's IRQ 13 from the FPU.

Well, on the PIIX it is and I guess on anything where it's _not_ fully 
internal an 0xf0 write wouldn't have any effect on IRQ13...

When you earlier mentioned this it seemed 0xed switched on DMI would be good 
enough, but well.

Alan, do you have an opinion on the port 0xf0 write? It should probably 
still be combined with a replacement/deletion for new machines due to the 
bus-locking "bad for real-time" thing you mentioned earlier but in the short 
run it could be a fairly low-impact replacement on anything except a 386+387

We should do a another timing measurement survey and it makes for sligtly 
worse code if we indeed feel it's not safe enough to write anything other 
than 0, but otherwise it's quite minimal.

Rene.

