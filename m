Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbYAPTP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbYAPTP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYAPTPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:15:20 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41628 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYAPTPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:15:18 -0500
Message-ID: <478E57C8.2080403@davidnewall.com>
Date: Thu, 17 Jan 2008 05:45:20 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "David P. Reed" <dpreed@reed.com>, David Woodhouse <dwmw2@infradead.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com>	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	<47845972.9090803@zytor.com>	<1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>	<47854916.4080703@reed.com>	<1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>	<4786DD05.20804@keyaccess.nl>	<47877ECD.9060408@reed.com>	<1200347847.2647.97.camel@shinybook.infradead.org>	<478BE08B.3090306@reed.com>	<478E1668.9040404@davidnewall.com> <20080116145515.6d84dc7b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080116145515.6d84dc7b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 17 Jan 2008 01:06:24 +1030
> David Newall <davidn@davidnewall.com> wrote:
>
>   
>> This use of port 80 (or insert some other random number) is a croc of
>> hackery of the most inexperienced kind. 
>>     
>
> Wrong. It's a careful designed solution used by all sorts of code for
> over 15 years.
>   
It's not careful: it's a croc.  It's an ugly hack, an abuse of process,
and totally unnecessary.  Read my comment about delays (next).

>  The task to be performed is to delay for some period
>
> Wrong, it is for some number of bus clocks which is why I/O cycles are
> used
>   
Wrong.  It's a delay.  It's a delay measured in I/O cycles, but still a
delay.  Doing I/O to get a delay, even if the delay is intended to be
measured in I/O cycles, is hackery of the most inexperienced sort.  It's
the sort of thing junior programmers get boxed in the ear for.  There's
no satisfactory reason to do it that way.

If the hardware required an intermediate junk I/O, that would be a
reason to do one, but it doesn't, does it?  It requires a delay.  It's
written thus in all of the application notes.

>> that an OUT is used because you don't know how long the delay should be
>> on any specific machine.  What rubbish.
>>     
>
> Wrong again.
>   
Wrong again.  Of course one knows how long the delay should be.  The bus
speed is known.  The specifications of the hardware is known.  Do the
math you (the programmer writing the driver, not Alan) lazy sluggard,
and use a delay.  It baffles commonsense to say you don't know how long
it should be.

>> I won't even mention the many instances of these delays where no delay
>> is what properly is needed.  Performance?  Who cares about performance?
>>     
>
> Correctness, who needs correctness ?
Well, frankly, the development process could stand a little more of it.


The sooner we stop denying that this is a hack, the sooner we can fix it.
