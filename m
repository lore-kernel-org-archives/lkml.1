Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbXLOR6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbXLOR6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 12:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbXLOR6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 12:58:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55466 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751604AbXLOR63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 12:58:29 -0500
Date: Sat, 15 Dec 2007 17:51:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rene Herman <rene.herman@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
Message-ID: <20071215175117.17e5d5ee@the-village.bc.nu>
In-Reply-To: <4763FE7A.4000105@reed.com>
References: <1184218962.12353.209.camel@chaos>
	<46964352.7040301@reed.com>
	<1184253339.12353.223.camel@chaos>
	<469697C6.50903@reed.com>
	<1184274754.12353.254.camel@chaos>
	<4761F193.7090400@reed.com>
	<20071214131502.GA14359@elte.hu>
	<4762C551.5070003@zytor.com>
	<20071215074358.GD12110@elte.hu>
	<4763891A.3010004@gmail.com>
	<20071215132725.GA23166@elte.hu>
	<20071215142929.5462b329@the-village.bc.nu>
	<4763FE7A.4000105@reed.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a minor concern, but I did also point out that using an unused port 
> causes the bus to be tied up for a microsecond or two, which matters on 
> a fast SMP machine.

And I did point out I'd found locking cases that may be relying upon this

> I also note that curent machines like the problem machine have ACPI, and 
> maybe those would be the ones that vendors might start to define port 80 
> to mean something. As I noted, it /seems/ to be only when ACPI is turned 

Port 0x80 means debug. You appear to have a laptop with some kind of
buggy firmware that wants a BIOS update. Everyone use 0x80 for debug -
its in the chipset hardware quite often.

> My belief is that my machine has some device that is responding to port 
> 80 by doing something.  And that something requires some other program 
> to "service" port 80 in some way.  But it sure would be nice to know.   
> I can't personally sand off the top of the chipset to put probes into it 
> - so my normal approach of putting a logic analyzer on the bus doesn't work.

Almost certainly a SMI trap.

> PS: If I have time, I may try to build Rene's port 80 test for Windows 
> and run it under WinXP on this machine 

That would be very interesting.

Alan
