Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbXEFXf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbXEFXf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXEFXf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:35:59 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50825 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752221AbXEFXf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:35:59 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: console font limits
Date: Sun, 6 May 2007 19:35:53 -0400
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com> <1178254748.4722.4.camel@daplas> <200705040834.41000.jbarnes@virtuousgeek.org>
In-Reply-To: <200705040834.41000.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705061935.53601.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007 11:34:40 Jesse Barnes wrote:
> On Thursday, May 03, 2007, Antonino A. Daplas wrote:
> > On Thu, 2007-05-03 at 23:58 -0400, Daniel Hazelton wrote:
> > > On Thursday 03 May 2007 20:39:05 H. Peter Anvin wrote:
> > > > Kyle Moffett wrote:
> > >
> > > I guess I could start on that work again - shouldn't take me all that
> > > long to recover the stuff I lost when a blackout caused my hard drive
> > > to get corrupted beyond recovery (and the automated journal replay
> > > didn't do a damned thing - I think it actually *added* to the
> > > corruption, but I don't think any filesystem would have survived that)
> >
> > You might want to look at the modesetting-101 branch of DRM.  It's goal
> > is similar to yours.  They even have a drm framebuffer.  I don't know
> > how far they are with their goal, but I can see some progress.
> >
> > Here's their git tree:
> >
> > git://git.freedesktop.org/git/mesa/drm#modesetting-101

Nope. Address doesn't work for me. 

> It sounds like we'll need a new KD_* flag for this work too, something like
> KD_TEXT_BUT_ONLY_ON_PANIC, sine with the above tree, the kernel will have
> intimite knowledge of the current graphics mode, framebuffer location,
> etc.  It should be enough to clear the scanout buffer and output the
> printk, though if there's a lot of rendering going on, the DRM driver
> might have to be pretty smart about it.

Yeah, I had thought about this. What I was thinking was that, on panic, the 
kernel could either kill the graphics mode entirely or do something like what 
the Amiga used to do - ie: scroll the screeen *down* and insert the error 
output at the top. (well, the opposite, really - scroll up and insert, just 
to keep the code simple and elegant)

Other than that, well... I figure that if the kernel is using DRM internally 
it can easily tell DRM to cancel out all extended rendering contexts - 
OpenGL, overlays and such - when the panic happens.

DRH

