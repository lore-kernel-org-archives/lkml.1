Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYAAVSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYAAVSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYAAVSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:18:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbYAAVSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:18:12 -0500
Message-ID: <477AADC1.3030503@zytor.com>
Date: Tue, 01 Jan 2008 13:16:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu>	<20071215080831.404cdb32@tux.DEF.witbe.net>	<47638C8C.2090604@gmail.com>	<476438B4.2020600@zytor.com>	<476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<4765D95C.4010404@zytor.com>	<4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A62F4.9010504@reed.com>
In-Reply-To: <477A62F4.9010504@reed.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> Alan, thank you for the pointers.  I have been doing variations on this 
> testing theme for a while - I get intrigued by a good debugging 
> challenge, and after all it's my machine...
> 
> Two relevant new data points, and then some more suggestions:
> 
> 1. It appears to be a real port.  SMI traps are not happening in the 
> normal outb to 80.  Hundreds of them execute perfectly with the expected 
> instruction counts.  If I can trace the particular event that creates 
> the hard freeze (getting really creative, here) and stop before the 
> freeze disables the entire computer, I will.  That may be an SMI, or 
> perhaps any other kind of interrupt or exception.  Maybe someone knows 
> how to safely trace through an impending SMI while doing printk's or 
> something?
> 
> 2. It appears to be the standard POST diagnostic port.  On a whim, I 
> disassembled my DSDT code, and studied it more closely.   It turns out 
> that there are a bunch of "Store(..., DBUG)" instructions scattered 
> throughout, and when you look at what DBUG is defined as, it is defined 
> as an IO Port at IO address DBGP, which is a 1-byte value = 0x80.  So 
> the ACPI BIOS thinks it has something to do with debugging.   There's a 
> little strangeness here, however, because the value sent to the port 
> occasionally has something to do with arguments to the ACPI operations 
> relating to sleep and wakeup ...  could just be that those arguments are 
> distinctive.
> 

Dumb question: if you change your iodelay function so it always writes 
zero to port 0x80, does it start working?

	-hpa
