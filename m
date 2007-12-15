Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbXLOFq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbXLOFq2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 00:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXLOFqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 00:46:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbXLOFqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 00:46:19 -0500
Message-ID: <476369E2.8050301@zytor.com>
Date: Fri, 14 Dec 2007 21:45:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <4763442A.5020507@reed.com>
In-Reply-To: <4763442A.5020507@reed.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> Just a thought for a way to fix the "very early" timing needed to set up 
> udelay to work in a way that works on all machines.  Perhaps we haven't 
> exploited the BIOS enough:  The PC BIOS since the PC AT (286)  has 
> always had a standard "countdown timer" way to delay for n microseconds, 
> which as far as I know still works.   This can be used to measure the 
> speed of a delay loop, without using ANY in/out instructions directly 
> (the ones in the BIOS are presumably correctly delayed...).

If we enter from the 32-bit entrypoint, we already don't have access to 
the BIOS, though.

	-hpa
