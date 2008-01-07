Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYAGXDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYAGXDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYAGXC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:02:59 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:51850 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYAGXC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:02:58 -0500
Message-ID: <4782AED5.1060406@keyaccess.nl>
Date: Mon, 07 Jan 2008 23:59:33 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Christer Weinigel <christer@weinigel.se>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it> <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it> <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it> <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it> <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it> <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it> <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com> <alpine.LSU.0.999.0801072226060.16143@be1.lrz> <4782A355.1070207@zytor.com> <alpine.LSU.0.999.0801072316440.16143@be1.lrz>
In-Reply-To: <alpine.LSU.0.999.0801072316440.16143@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-01-08 23:27, Bodo Eggert wrote:

> On Mon, 7 Jan 2008, H. Peter Anvin wrote:

>> There might have been a few 386/20's clocking the ISA bus at ­­÷3 (6.67
>> MHz) rather than ÷2 (10 MHz) or ÷2.5 (8 MHz).
> 
> Yes, and the remaining users should set the kernel option. Both of them. 
> The question is: How will they be told about the new kernel option?

What exactly are you guys still talking about? Alan is looking at drivers 
and finds that in them outb_p is generally correct and correctly specified 
in bus-clocks for at least some (8390 was quoted). In those legacy drivers, 
the _p ops can simply stay and can use the 15-year old proven 0x80 outb.

(with molnar suggesting they be renamed isa_in/outb_p and me suggesting that 
if someone would be doing _that_ they might as well split them manually in 
outb(); slow_down_io() possibly renaming slow_down_io() to isa_io_delay() or 
similar).

Is this only about the ones then left for things like legacy PIC and PIT? 
Does anyone care about just sticking in a udelay(2) (or 1) there as a 
replacement and call it a day?

Rene.

