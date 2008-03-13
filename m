Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYCMRJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYCMRJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYCMRJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:09:07 -0400
Received: from outbound-mail-10.bluehost.com ([69.89.17.210]:43530 "HELO
	outbound-mail-10.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750982AbYCMRJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:09:06 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Thu, 13 Mar 2008 10:09:01 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <47D828BB.2000702@gawab.com> <200803121236.43267.jbarnes@virtuousgeek.org> <47D8BF6A.9020905@gawab.com>
In-Reply-To: <47D8BF6A.9020905@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131009.01889.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 12, 2008 10:45 pm Justin Madru wrote:
> Jesse Barnes wrote:
> > It's kind of hard to read the context diff (unified diffs are much nicer)
> > but nothing jumps out at me regarding your video config.  Does the blank
> > screen problem occur if you disable usplash altogether and compile out
> > the fb drivers?  The intelfb driver in particular can cause problems
> > sometimes since it supports so few configurations, you might try the
> > vesafb driver too.
>
> Sorry about the diff. So I should always use "diff -u"?

Yeah, diff -u is easier to read IMO.

> Anyways, I removed the frame buffer (see diff below if I did it right),
> and it seems to fix the problem.
> Although, the blank screen _randomly_ happened so I'll have to test it
> out for a while.
> It seems like I only get the blank screen when I first boot the computer
> after it's been off for a while.
> I just tried to trigger the blank screen by repeatedly rebooting but I
> wasn't able except for once, the first boot. ;(
>
> Does this seem reasonable? or just a coincidence.

Well, the blank screen is probably due to a pipe programming timing problem.  
IGD devices have been getting less & less sensitive to it over time (830s 
would hang if you looked at them the wrong way) but it's still not that hard 
to mis-program them.

Can you narrow down the problem at all?  Did it occur just after a kernel 
upgrade?  Or did you also upgrade your X driver?  There haven't been any real 
changes in intelfb since Oct. when Krzysztof added interlaced mode support, 
so it's weird that you're just seeing problems now...

> By the way, what is the frame buffer for? Does it have anything to do
> with the X server?

The framebuffer drivers provide a simple interface to applications wanting to 
draw to the screen.  It's usually used in embedded devices and for boot 
splash screens.  Generally you don't want to run X through the framebuffer 
APIs though; it'll be really slow compared to a proper X 2D driver.

> For instance, keeping it removed doesn't remove anything necessary? I
> just use GNOME, programs and Compiz Fusion. And why would I start to
> have this problem with the 2.6.25 kernel and not 2.6.24? Did the intelfb
> change?

I think the only thing you'll lose is the boot splash screen.  But you could 
also try using vesafb.  It works with more hardware than intelfb (including 
laptops) and we've fixed some vesafb related bugs in the X driver recently, 
so it may work better for you.

Jesse
