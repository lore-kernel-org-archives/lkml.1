Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbXLKUBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbXLKUBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbXLKUBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:01:47 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:46301 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbXLKUBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:01:47 -0500
Message-ID: <475EEC10.8020300@keyaccess.nl>
Date: Tue, 11 Dec 2007 20:59:12 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org> <475EBFBA.6090301@keyaccess.nl> <20071211191649.GB3437@elf.ucw.cz>
In-Reply-To: <20071211191649.GB3437@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 20:16, Pavel Machek wrote:

>> Pavel Machek already posted one. His udelay(8) wants to be less -- 1 or "to 
>> be safe" perhaps 2.
>>
>> http://lkml.org/lkml/2007/12/9/131
> 
> 2 at least; that's how long outb(0x80) takes on one of my
> machines. Actually, ISA can go down to 4MHz, so maybe we should be
> using 4 usec.... but I guess I'm paranoid here.

4 isn't sensible. There have been machines capable both of running Linux and 
their ISA bus at less than 8 MHz (if only for example by picking a 5 divisor 
on a system that was capable of hosting a 40 Mhz 386/486 but using a slower 
CPU) but not by much. And machines doing that and running Linux, even more 
so "today": 0.

My posted test program (although there seems to be something wrong with it 
since it's influenced by compiler optimisation) is showing more than 1 but 
note that on the vast majority of machines, 0 would in fact do. 1 will on 
all, 2 will as well.

Rene.

