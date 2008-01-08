Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYAHSyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYAHSyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYAHSyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:54:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40306 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643AbYAHSyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:54:23 -0500
Date: Tue, 8 Jan 2008 18:51:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
Message-ID: <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>
In-Reply-To: <4783C4A6.9060402@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<200801081810.58904.linux@rainbow-software.org>
	<4783B1B2.6070005@reed.com>
	<200801081838.16241.linux@rainbow-software.org>
	<4783C4A6.9060402@reed.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no need to use io writes to supposedly/theoretically "unused 
> ports" to make drivers work on any bus.

The natsemi docs here say otherwise. I trust them not you.

> don't remember writing a driver for the 3com devices - probably didn't, 
> because 3Com's cards were expensive at the time.

3C503 needs delays for some setups according to the docs. I can't tell
you how the 3COM drivers did it as that was a different bit of 3com to
the bit I worked for. From the rest of 3Com I saw probably utterly
vilely ;)

Later 3Com stuff was either sane (3c509 etc) or used whacko intel chips
(3c507/27) which had their own special breed of insanity to replace
address setup delay bugs.

> In any case, Linux *did* adopt this port 80 strategy - I'm sure all 
> concerned thought it was frightfully clever at the time.  Linus 
> expressed his skepticism in the comments in io.h.  The problem is to 
> safely move away from it toward a proper strategy 

No. The problem is that certain people, unfortunately those who know
nothing about ISA related bus systems, keep trying to confuse ISA delay
logic with core chip logic and end up trying to solve both a problem and a
non-problem in one, creating a nasty mess in the process.

Alan
