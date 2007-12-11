Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbXLKTQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbXLKTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXLKTQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:16:20 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40068 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750785AbXLKTQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:16:19 -0500
Date: Tue, 11 Dec 2007 20:16:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071211191649.GB3437@elf.ucw.cz>
References: <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org> <475EBFBA.6090301@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EBFBA.6090301@keyaccess.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> Anyways it looks like the discussion here is going in a
>> a loop. I had hoped David would post his test results with
>> another port so that we know for sure that the bus aborts (and not port 
>> 80) is the problem on his box. But it looks like
>> he doesn't want to do this. Still removing the bus aborts
>> is probably the correct way to go forward.
>
> Yes, I do also still want to know that. David (Reed)?
>
>> Only needs a patch now. If nobody beats me to it i'll
>> add one later to my tree.
>
> Pavel Machek already posted one. His udelay(8) wants to be less -- 1 or "to 
> be safe" perhaps 2.
>
> http://lkml.org/lkml/2007/12/9/131

2 at least; that's how long outb(0x80) takes on one of my
machines. Actually, ISA can go down to 4MHz, so maybe we should be
using 4 usec.... but I guess I'm paranoid here.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
