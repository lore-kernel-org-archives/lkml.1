Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZBVLQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZBVLQF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 06:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZBVLPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 06:15:53 -0500
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:19836 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZBVLPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 06:15:53 -0500
Date: Sun, 22 Feb 2009 12:20:44 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Risto Suominen <risto.suominen@gmail.com>
Cc: adaplas@pol.net, Andrew Morton <akpm@linux-foundation.org>,
       geert@linux-m68k.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
Message-Id: <20090222122044.ca7e6106.krzysztof.h1@poczta.fm>
In-Reply-To: <46e1c7760902220125l61700421gc4045ca10ea4dd10@mail.gmail.com>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	<46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	<Pine.LNX.4.64.0901241425310.13803@anakin>
	<46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	<46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
	<46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
	<20090211142409.b88c577e.akpm@linux-foundation.org>
	<46e1c7760902121312o1476e734xc1fc1d6e11ce4d2e@mail.gmail.com>
	<20090213210635.d094ffc8.krzysztof.h1@poczta.fm>
	<20090222081517.567a29bd.krzysztof.h1@poczta.fm>
	<46e1c7760902220125l61700421gc4045ca10ea4dd10@mail.gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: b0e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009 11:25:04 +0200
Risto Suominen <risto.suominen@gmail.com> wrote:

> Krzysztof, thank you for your efforts.
> 
> I've been using PowerMac platform with built-in ATI mach64 and Xorg
> server 1.1.1. 

I will try to reproduce the problem with Xorg 1.1.1 and your options.
I do not have the PowerMac and the ATI mach64 card.

> 
> In my opinion, Xfbdev assumes that the cursor will disappear when
> turning on graphics mode with ioctl(LinuxConsoleFd, KDSETMODE,
> KD_GRAPHICS). It's obvious that fbcon is not doing anything to switch
> the cursor off when it receives this ioctl, fbcon_is_inactive()
> prevents it. The problem comes from that something has made it appear,
> i.e. text mode frame buffer console. I have text consoles on VTs 1 to
> 6 and X on 7.
> 


> One maybe unusual property of atyfb is that the frame buffer is higher
> than the screen. To make Xfbdev work correctly I needed the patch
> below.
> 

The patch is not a correct fix. A simple workaround is to set a vyres = yres
and disable panning. I am able to reproduce this problem. A cause is
that Xfbdev prints some messages after it set up graphics mode, so
the screen got scrolled. I do not know what is an expected behaviour
(maybe with KD_GRAPHICS no messages should be printed).

Regards,
Krzysztof


----------------------------------------------------------------------
Zostan mistrzem parkowania w Bombaju!
Zagraj >> http://link.interia.pl/f204e 

