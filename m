Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYAAVW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYAAVW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYAAVWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:22:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbYAAVWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:22:51 -0500
Message-ID: <477AAEEB.5060407@zytor.com>
Date: Tue, 01 Jan 2008 13:21:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com>	<20080101161557.3ce2d5f8@the-village.bc.nu>	<20080101164338.GA901@elte.hu>	<20080101183238.74307174@weinigel.se>	<20080101184659.GA9250@elte.hu> <20080101203518.26e889f2@weinigel.se>
In-Reply-To: <20080101203518.26e889f2@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel wrote:
> 
> out 80h, al is only two bytes.  Any alternative that has been suggested
> in this discussion will use more space.  mov dx, alt_port; out dx, al
> will be larger, a function call will definitely be a lot larger. People
> have been making changes to the kernel to save a couple of hundred
> bytes of text size.
> 

If text size becomes a problem in this case, then we can use an 
alternatives-like mechanism to fix up the kernel.  However, 
realistically this probably should be a function call *combined with* 
the out and in; that reduces the impact somewhat.

	-hpa
