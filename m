Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXLORST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXLORST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 12:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbXLORSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 12:18:09 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:58926 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbXLORSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 12:18:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+7K5wVU6tSKJq6980YV2SX
Message-ID: <47640C33.1050106@reed.com>
Date: Sat, 15 Dec 2007 12:17:39 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <4763442A.5020507@reed.com> <476369E2.8050301@zytor.com>
In-Reply-To: <476369E2.8050301@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> David P. Reed wrote:
>> Just a thought for a way to fix the "very early" timing needed to set 
>> up udelay to work in a way that works on all machines.  Perhaps we 
>> haven't exploited the BIOS enough:  The PC BIOS since the PC AT 
>> (286)  has always had a standard "countdown timer" way to delay for n 
>> microseconds, which as far as I know still works.   This can be used 
>> to measure the speed of a delay loop, without using ANY in/out 
>> instructions directly (the ones in the BIOS are presumably correctly 
>> delayed...).
>
> If we enter from the 32-bit entrypoint, we already don't have access 
> to the BIOS, though.
>
My understanding is that the linux starts in real mode, and uses the 
BIOS for such things as reading the very first image.   
arch/x86/boot/main.c seems to use BIOS calls, and one can do what I 
wrote in C or asm.  Good place to measure the appropriate delay timing, 
and pass it on forward.  That's what I was suggesting, which is why I 
copied the ASM routine from my old code listing as I did.

