Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbYAHONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbYAHONS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbYAHONF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:13:05 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49744 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbYAHONE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:13:04 -0500
Message-ID: <4783841C.1030002@keyaccess.nl>
Date: Tue, 08 Jan 2008 15:09:32 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Christer Weinigel <christer@weinigel.se>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it> <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it> <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it> <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it> <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it> <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it> <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com> <alpine.LSU.0.999.0801072226060.16143@be1.lrz> <4782A355.1070207@zytor.com> <alpine.LSU.0.999.0801072316440.16143@be1.lrz> <4782AED5.1060406@keyaccess.nl> <4782B4B9.2020608@zytor.com> <4782B515.3010008@keyaccess.nl> <alpine.LSU.0.999.0801081333530.12636@be1.lrz>
In-Reply-To: <alpine.LSU.0.999.0801081333530.12636@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-01-08 13:51, Bodo Eggert wrote:

> On Tue, 8 Jan 2008, Rene Herman wrote:

>>>> Is this only about the ones then left for things like legacy PIC and PIT?
>>>> Does anyone care about just sticking in a udelay(2) (or 1) there as a
>>>> replacement and call it a day?
>>>>
>>> PIT is problematic because the PIT may be necessary for udelay setup.
>> Yes, can initialise loops_per_jiffy conservatively. Just didn't quite get why
>> you guys are talking about an ISA bus speed parameter.
> 
> If the ISA bus is below 8 MHz, we might need a longer delay. If we default
> to the longer delay, the delay will be too long for more than 99,99 % of 
> all systems, not counting i586+. Especially if the driver is fine-tuned to 
> give maximum throughput, this may be bad.

Yes, and I repeat -- old legacy ISA drivers can stay as they are. They've 
been doing what they've been doing for 15 years and given that the systems 
that break don't use them there is no practical upside to changing them and 
a big downside particularly with respect to difficulty of testing.

A somewhat overly long delay shouldn't be particularly problematic for the 
few remaining legacy hardware users _outside_ drivers/

Rene.
