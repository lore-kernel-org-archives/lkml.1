Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbXCIUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbXCIUjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXCIUjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:39:18 -0500
Received: from khc.piap.pl ([195.187.100.11]:37145 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbXCIUjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:39:17 -0500
To: "Tosoni" <jp.tosoni@acksys.fr>
Cc: "'Carl-Daniel Hailfinger'" <c-d.hailfinger.devel.2006@gmx.net>,
       "'Robin Getz'" <rgetz@blackfin.uclinux.org>,
       "'Oleksiy Kebkal'" <kebkal@gmail.com>,
       "'Mike Frysinger'" <vapier.adi@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <linux-serial@vger.kernel.org>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
References: <000201c761b1$a281cdf0$2e01a8c0@acksys.local>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 09 Mar 2007 21:39:14 +0100
In-Reply-To: <000201c761b1$a281cdf0$2e01a8c0@acksys.local> (Tosoni's message of "Thu, 8 Mar 2007 19:43:15 +0100")
Message-ID: <m3irdaywwd.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Tosoni" <jp.tosoni@acksys.fr> writes:

>> OTOH I wonder what does the device in question require WRT the
>> serial port and WRT RTS line in particular.
>> I know there are some half-duplex converters which drive RTS only
>> while sending and which require CTS to send.
>
> As far as I know in the old times this was the *standard* way to use a modem
> (per CCITT V24), and even nowadays many modems can handle this method for
> transmit, to stay compatible with the standard.

I think it wasn't standard for real modems as they were full-duplex
(even these 1200/75 or what was that) but it was for other devices
such as current loops (which were frequently half-duplex).

I've seen such devices quite recently, perhaps ~ 10 years ago.
OTOH I think even "current" PC BIOSes use such signaling.

> Think of radio modems. Some are inherently half duplex.

Sure. But /dev/ttyS* ports are full-duplex, with CRTSCTS or without,
so they don't use such handshaking.

>> They are perhaps a bit broken <snip>
> No, no, they apply an old standard. Probably they are old as well.

I was thinking of a particular piece of hardware and it was definitely
broken a bit. "Selective compliance", maybe.

> It's a pity that Linux (or Unixes) never handled RTS this way.
> I feel that the /proc or sysfs solutions are the best to alter this well
> established default in this driver. It would not break existing installed
> hardware.

/proc is probably no-no.

For such signaling, it would perhaps be better to invent another flag,
similar to CRTSCTS. The driver would, of course, need some real code
for that.
-- 
Krzysztof Halasa
