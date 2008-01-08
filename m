Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYAHTw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYAHTw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYAHTwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:52:18 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:65145 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYAHTwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:52:18 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.106
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+toVjAVnqcDWI9ES/pvKEw
Message-ID: <4783D449.4050406@reed.com>
Date: Tue, 08 Jan 2008 14:51:37 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ondrej Zary <linux@rainbow-software.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com> <20080108192313.1c2d222a@lxorguk.ukuu.org.uk>
In-Reply-To: <20080108192313.1c2d222a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan -

I dug up a DP83901A SNIC datasheet in a quick Google search, while that 
wasn't the only such chip, it was one of them.  I can forward the PDF 
(the www.alldatasheet.com site dynamically creates the download URL), if 
anyone wants it.
The relevant passage says, in regard to delaying between checking the 
CRDA addresses to see if a dummy "remote read" has been executed., and 
in regard perhaps to other card IO register loops: 
                                                         

    TIME BETWEEN CHIP SELECTS
                                                                 
    The SNIC requires that successive chip selects be no
    closer                                                     
    than 4 bus clocks (BSCK) together. If the condition is
    violat-                                           
    ed the SNIC may glitch ACK. CPUs that operate from pipe-
    lined instructions (i e 386) or have a cache (i e 486) can
    execute consecutive I O cycles very quickly The solution is
    to delay the execution of consecutive I O cycles by either
    breaking the pipeline or forcing the CPU to access outside
    its cache.

The NE2000 as I recall had no special logic on the board to protect the 
chip from successive chip selects that were too close - which is the 
reason for the problem. Clearly an out to port 80 takes more than 4 ISA 
bus clocks, so that works if the NE2000 is on the ISA bus,   On the 
other hand, there are other ways to delay more than 4 ISA bus clocks.  
And as you say, one needs a delay for this chip that relates to the 
chip's card's bus's clock speed, not absolute time.

Alan Cox wrote:
>> As well you should. I am honestly curious (for my own satisfaction) as 
>> to what the natsemi docs say the delay code should do  (can't imagine 
>> they say "use io port 80 because it is unused").  I don't have any 
>>     
>
> They say you must allow 4 bus clocks for the address decode. They don't
> deal with the ISA side as the chip itself has no ISA glue.
>
>
>   
>> copies anymore. But mere curiosity on my part is not worth spending a 
>> lot of time on - I know you are super busy.   If there's a copy online 
>> at a URL ...
>>     
>
> Not that I know of. There may be. A good general source of info is Russ
> Nelson's old DOS packet driver collection.
>
>
>   
