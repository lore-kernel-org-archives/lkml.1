Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbXLKQa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbXLKQa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXLKQaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:30:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34197 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbXLKQaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:30:20 -0500
Date: Tue, 11 Dec 2007 17:30:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: David Newall <david@davidnewall.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071211163017.GD16750@one.firstfloor.org>
References: <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Most, probably most-all, of the delays to port operations
> on modern ix86 machines are not needed at all. Certainly

We know this. The problem is that there is no good known way to 
figure out which machines need it. Also it is typically 
slow hardware anyways -- the most time critical is probably
the 8259, but nobody who cares about performance still uses 
it except as a fail safe fallback and for those it is better
to be conservative.

> machines that use bridges to expand port I/O to the ISA
> bus do need any such delays. There are exactly two (and

It has been observed to be required talking to some older 
PCI based northbridges too. 

> (2) I/O operations that have two ports, one an index
> port and the other a data port, like the CMOS RTC. Once

and PIT etc.

Anyways it looks like the discussion here is going in a
a loop. I had hoped David would post his test results with
another port so that we know for sure that the bus aborts 
(and not port 80) is the problem on his box. But it looks like
he doesn't want to do this. Still removing the bus aborts
is probably the correct way to go forward.

Only needs a patch now. If nobody beats me to it i'll
add one later to my tree.

-Andi

