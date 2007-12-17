Return-Path: <linux-kernel-owner+w=401wt.eu-S936217AbXLQU6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936217AbXLQU6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759608AbXLQU6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:58:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbXLQU6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:58:40 -0500
Message-ID: <4766E2B5.8080001@zytor.com>
Date: Mon, 17 Dec 2007 12:57:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<20071217105744.GA14315@elte.hu>	<4766684D.40202@gmail.com>	<20071217130933.GB27992@elte.hu>	<47667812.8050708@gmail.com>	<47667A85.3080100@reed.com>	<20071217143900.GA16604@elte.hu> <20071217161243.05c32df4@the-village.bc.nu> <4766E086.9090500@gmail.com>
In-Reply-To: <4766E086.9090500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 17-12-07 17:12, Alan Cox wrote:
> 
>> I don't think we should be offering udelay based delays at this point.
>> There are a lot of drivers to fix first. This is just one trivial example
> 
> I agree. This thread's too full of people calling this outb method a 
> dumb hack. It's a well-known legacy PC thing and while in practice the 
> udelay might be a functional replacement for a majority of cases (save 
> the races you are finding) a delay proportional to the bus speed makes 
> great sense certainly when talking to hardware that itself runs 
> proportinal to the bus speed for example.
> 
> So, really, how about just sticking in this minimal version for now? 
> Only switches the port to 0xed based on DMI and is all that is needed to 
> fix the actual problem. This should be minimal and no-risk enough that 
> it could also go to .24 if people want it to. It'll fix a few HP laptops 
> (I'll try and get/verify the dv6000z DMI strings as well).
> 

I think retaining the command-line option available is a good thing, 
though.  If nothing else, it is something very quick we can ask other 
people to try if they seem to have similar problems.

Other than that, this alternate-port patch is a low-impact patch not 
affecting hardware not on the blacklist, which makes it appropriate for 
2.6.24 IMO.

	-hpa
