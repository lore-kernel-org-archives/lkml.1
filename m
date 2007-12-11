Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbXLKX5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbXLKX5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXLKX5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:57:06 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:58249 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155AbXLKX5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:57:04 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19TgTtMA5NL2ZB3klZvEZxP
Message-ID: <475F23BD.3040903@reed.com>
Date: Tue, 11 Dec 2007 18:56:45 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org> <20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <20071211143224.15900995@tux.DEF.witbe.net> <475E9B9B.2050709@keyaccess.nl> <475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl> <475EC1C0.2040000@reed.com> <20071211173231.2b87a81f@the-village.bc.nu> <475EE2CA.6020601@reed.com> <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) I found in a book, the Undocumented PC, that I have lying around that 
the "pause" recommended for some old adapter chips on the ISA bus was 1 
usec.  The book carefully points out on various models of PCs how many 
short jumps are required to implement 1 usec, and suggests that for 
faster machines, 1 usec loops be calibrated.  That seems like a good 
heuristic.

2) Also, Dick, you got me interested in doing more historical research 
into electrical specs and circuit diagrams (which did come with the IBM 
5150).  The bus in the original IBM PC had no problem with "bus capacity 
being charged" as you put it.   Perhaps you don't remember that the I/O 
bus had the same electrical characteristics as the memory bus.  Thus 
there is no issue with the bus being "charged".  The issue of delays 
between i/o instructions was entirely a problem of whether the adapter 
card could clock data into its buffers and handle the clocked in data in 
time for another bus cycle.  This had nothing to do with "charging" - 
buses in those days happily handled edges that were much faster than 1 usec.

We at Software Arts did what we did based on direct measurements and 
testing.  We found that the early BIOS listings were usually fine, but 
in fact were misleading. After all, the guys who built the machine and 
wrote the BIOS were in a hurry.  There were errata. 

linux-os (Dick Johnson) wrote:
> You do remember that the X86 can do back-to-back port
> instructions faster than the ISA bus capacity can be
> charged, don't you? You do remember the admonishment
> about:
>  	intel asm
>
>  	mov	dx, port	; One of two adjacent ports
>  	mov	al,ffh		; All bits set
>  	out	dx,al		; Output to port, bits start charging bus
>  	inc	al		; Al becomes 0
>  	inc	dx		; Next port
>  	out	dx,al		; Write 0 there, data bits discharged
>
> When the port at 'port' gets its data, it will likely
> be 0, not 0xff, because the intervening instructions
> can execute faster than a heavily-loaded ISA bus.
>
>   
