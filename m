Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYAHSpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYAHSpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYAHSp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:45:29 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:53964 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYAHSp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:45:27 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.106
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19RYfw8mgv+Purs36zrTl7W
Message-ID: <4783C4A6.9060402@reed.com>
Date: Tue, 08 Jan 2008 13:44:54 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Bodo Eggert <7eggert@gmx.de>, Christer Weinigel <christer@weinigel.se>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it> <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com> <200801081838.16241.linux@rainbow-software.org>
In-Reply-To: <200801081838.16241.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ondrej Zary wrote:
> On Tuesday 08 January 2008 18:24:02 David P. Reed wrote:
>   
>> Windows these days does delays with timing loops or the scheduler.  It
>> doesn't use a "port".  Also, Windows XP only supports machines that tend
>> not to have timing problems that use delays.  Instead, if a device takes
>> a while to respond, it has a "busy bit" in some port or memory slot that
>> can be tested.
>>     
>
> Windows XP can run on a machine with ISA slot(s) and has built-in drivers for 
> some plug&play ISA cards - e.g. the famous 3Com EtherLink III. I think that 
> there's a driver for NE2000-compatible cards too and it probably works.
>   
There is no need to use io writes to supposedly/theoretically "unused 
ports" to make drivers work on any bus.
ISA included!  You can, for example, wait for an ISA bus serial adapter 
to put out its next character by looping reading the port that has the 
output buffer full flag in a tight loop, with no delay code at all.  And 
if you need to time things, just call a timing loop subroutine that you 
calibrate at boot time.
I wrote DOS drivers for NE2000's on the ISA bus when they were brand new 
designs from Novell without such kludges as writes to I/O port 80.  I 
don't remember writing a driver for the 3com devices - probably didn't, 
because 3Com's cards were expensive at the time.

In any case, Linux *did* adopt this port 80 strategy - I'm sure all 
concerned thought it was frightfully clever at the time.  Linus 
expressed his skepticism in the comments in io.h.  The problem is to 
safely move away from it toward a proper strategy that doesn't depend on 
"bus aborts" which would trigger machine checks if they were properly 
enabled.

