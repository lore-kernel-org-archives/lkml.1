Return-Path: <linux-kernel-owner+w=401wt.eu-S934969AbXLQTvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969AbXLQTvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932602AbXLQTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:39:05 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:56438 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760429AbXLQTjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:39:03 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.136
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Cz1gDK0N5ZJCqwyTTdxyn
Message-ID: <4766D035.7090104@reed.com>
Date: Mon, 17 Dec 2007 14:38:29 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com> <20071217143900.GA16604@elte.hu>
In-Reply-To: <20071217143900.GA16604@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo -

I finished testing the rolled up patch that you provided.  It seems to 
work just fine.  Thank you for putting this all together and persevering 
in this long and complex discussion. 

Here are the results, on the offending laptop, using 2.6.24-rc5 plus 
that one patch.

First: booted with normal boot parameters (no io_delay=):

    According to dmesg, 0xed is used.

    hwclock ran fine, hundreds of times.
    my shell script loop doing "cat /dev/nvram > /dev/null" ran fine, 
several times.
    Running Rene's "port 80" speed test ran fine once, then froze the 
system hard.  (expected)

Second: booted with io_delay=0x80, several tests, rebooting after freezes:

    hwclock froze system hard.  (this is the problem that drove me to 
find this bug).
    my shell script loop froze system hard.

Third: booted with io_delay=none:

    hwclock ran fine, also hundreds of times.
    my shell script loop ran fine several times.
    Running rene's port80 test ran fine twice, froze system hard on 
third try.

Fourth: booted with io_delay=udelay:

    hwclock ran fine, also hundreds of times.
    my shell script loop ran fine several times.
    Running Rene's port80 test ran fine, froze system hard on second try.

Analysis:

    patch works fine, and default to 0xed seems super conservative.
    I will probably use the boot parameter io_delay=none, because I 
don't seem to have any I/O
    devices that require any delays - and this way I can find any that do.

Still wondering:

    what the heck is going on with port 80 on my laptop motherboard.  
Clearly it "does something".
    I will in my spare time continue investigating, though having a 
reliable system is GREAT.




   

