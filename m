Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbXLLUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbXLLUIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbXLLUIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:08:09 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:55257 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXLLUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:08:07 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.165
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GkmWdzmxrJkZIyk3ugMsI
Message-ID: <47603F66.3070108@reed.com>
Date: Wed, 12 Dec 2007 15:07:02 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: More info on port 80 symptoms on MCP51 machine.
References: <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org> <475EBFBA.6090301@keyaccess.nl> <20071211191649.GB3437@elf.ucw.cz> <475EEC75.80609@keyaccess.nl>
In-Reply-To: <475EEC75.80609@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sadly, I've been busy with other crises in my day job for the last few 
days.   I did modify Rene's test program and ran it on my "problem" 
machine, with the results below.

The interesting part of this is that port 80 seems to respond to "in" 
instructions faster than the presumably "unused" ports 0xEC  and 0XEF  
(those were mentioned by someone as alternatives to port 80).

That, and the fact that the port 80 test reliably freezes the machine 
solid the second time it is run, and the "hwclock" utility reliably 
hangs the machine if the port 80's are used in the CMOS_READ/CMOS_WRITE 
loop, seems to strongly indicate that this chipset or motherboard 
actually uses port 80, rather than there being a bus problem.

Someone might have an in to nVidia to clarify this, since I don't.  In 
any case, the udelay(2) approach seems to be a safe fix for this machine.

Hope input from an "outsider" is helpful in going forward.   I put a lot 
of time and effort into tracking down this problem on this particular 
machine model, largely because I like the machine.

Running the (slightly modified to test ports 80, ec, ef instead of just 
port 80) test when the 2 GHz max speed CPU is running at 800 MHz, here's 
what I get for port 80 and port ec and port ef.

port 80:   cycles: out 1430, in 792
port ef:    cycles: out 1431, in 1378
port ec:   cycles: out 1432, in 1372
----------------------------

System info:  HP Pavilion dv9000z laptop (AMD64x2)

PCI bus controller is nVidia MCP51.
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-60
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
