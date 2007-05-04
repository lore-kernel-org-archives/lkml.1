Return-Path: <linux-kernel-owner+w=401wt.eu-S1767659AbXEDD7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767659AbXEDD7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 23:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767563AbXEDD7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 23:59:15 -0400
Received: from keil-draco.com ([216.193.185.50]:50139 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767659AbXEDD7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 23:59:14 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: console font limits
Date: Thu, 3 May 2007 23:58:55 -0400
User-Agent: KMail/1.9.6
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Albert Cahalan <acahalan@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com> <E0FF8D28-219F-44D5-88B4-BDE6A4D6605A@mac.com> <463A80A9.7030809@zytor.com>
In-Reply-To: <463A80A9.7030809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705032358.56055.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007 20:39:05 H. Peter Anvin wrote:
> Kyle Moffett wrote:
> > Actually I think the real problem was that "KD_GRAPHICS" got overloaded
> > to mean "some userspace program is probably poking at the GPU in very
> > direct ways possibly including /dev/mem".  As such it really isn't safe
> > at all for the kernel to write stuff to the screen in that situation;
> > you could turn a panic()+reboot-after-30-secs into an unrecoverable hard
> > PCI bus lockup.  IIRC there were at least a couple chipsets which had
> > that problem with X.  If we can implement enough APIs for X to do all of
> > its stuff from userspace without iopl() or /dev/mem then we could
> > probably bring back the option for dumping oopses to screen in
> > KD_GRAPHICS mode, but otherwise it'll just cause more headaches.
>
> It never meant anything *BUT* that, to the best of my knowledge.  That
> was certainly the original meaning of KD_GRAPHICS.

I started work last year on making the framebuffer layer use the DRM internals 
for all controls, providing a unified kernel and userspace system for 
accessing the graphics devices. It never got anywhere because I couldn't 
figure out a simple system for figuring out which driver (out of the numerous 
ones that could potentially be compiled into the kernel) to actually give 
control to. (I know I could have just looped over them all and figured it out 
that way, but that is far from elegant)

I guess I could start on that work again - shouldn't take me all that long to 
recover the stuff I lost when a blackout caused my hard drive to get 
corrupted beyond recovery (and the automated journal replay didn't do a 
damned thing - I think it actually *added* to the corruption, but I don't 
think any filesystem would have survived that)

DRH
