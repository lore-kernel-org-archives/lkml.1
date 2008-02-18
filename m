Return-Path: <linux-kernel-owner+w=401wt.eu-S1761378AbYBRVpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378AbYBRVpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760219AbYBRVp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:45:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbYBRVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:45:27 -0500
Message-ID: <47B9FC3A.2010508@zytor.com>
Date: Mon, 18 Feb 2008 13:44:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl>
In-Reply-To: <47B9F2EC.4070308@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> I mean that before the linux kernel used a port 0x80 write as an I/O 
> delay it used a short jump (two in a row actually...) as such and this 
> was at the time that it actually ran on the old legacy stuff that is of 
> most concern here.
> 
> No, if I'm not mistaken, those two jumps are actually what the udelay() 
> is going to do anyway as part of delay_loop() at that early stage so 
> that even before loops_per_jiffy calibration, I believe we should still 
> be okay.
> 

That doesn't make any sense at all.  The whole point why the two jumps 
were obsoleted with the P5 (or even late P4, if I'm not mistaken) was 
because they were utterly insufficient when the CPU ran at something 
much higher than the external speed.

> Yes, it's a bit of a "well, hrrm" thing, but, well... loops_per_jiffy 
> can be initialised a bit more conservatively then today as well (and as 
> discussed earlier, possibly per CPU family) but I believe it's actually 
> sort of fine not too worry much about it...

Uhm... no.  Quite the contrary, I would say.

	-hpa
