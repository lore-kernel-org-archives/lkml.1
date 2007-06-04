Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbXFDPkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbXFDPkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXFDPkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:40:33 -0400
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:49187 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755441AbXFDPkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:40:32 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matt Keenan <tank.en.mate@gmail.com>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Mon, 4 Jun 2007 08:40:21 -0700
User-Agent: KMail/1.9.6
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Andi Kleen <andi@firstfloor.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <Pine.LNX.4.64.0706021610210.19116@p34.internal.lan> <4662869A.9030700@gmail.com>
In-Reply-To: <4662869A.9030700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706040840.21593.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 3, 2007 2:15:06 Matt Keenan wrote:
> Justin Piszcz wrote:
> > On Sat, 2 Jun 2007, Andi Kleen wrote:
> >>> I feel, having a silent/transparent workaround is not a good idea.
> >>> With that
> >>
> >> If enough RAM is chopped off users will notice. They tend to complain
> >> when they miss RAM.  I don't like panic very much because for many
> >> users it will be a show stopper (even when they are not blessed
> >> with "quiet" boots like some distributions do)
> >>
> >> The message in dmesg could be also emphasized a bit with a little
> >> ASCII art (but no <blink> tag in there)
> >>
> >> The problem I'm more worried about is if the system will be really
> >> stable --- could it be that the memory controller is still
> >> misconfigured and cause other stability issues? (we've had such
> >> cases in the past). Also I'm not sure we can handle the case of
> >> the MTRR wrong not at the end of memory but at the hole sanely.
> >>
> >> -Andi
> >
> > So far I have been booting with mem=8832M and have run stress/loaded
> > the memory subsystem pretty good; what other tests should I run?
> >
> > It'd be nice if we could pose some sort of solution/warning for the
> > future so other people do not have to experience the same problems.
> >
> > What are the next steps?
>
> Wouldn't it be possible for the e820/MTRR set up code detect the problem
> and suggest a mem=xxxx that would fix the problem (while also
> complaining that the BIOS is broken)?

Yes, that should be fairly easy, though as Andi points out, if there are holes 
in the MTRR setup, things get a little trickier (I had an earlier patch to 
deal with this, but ended up with too many early boot issues).

Maybe what Venki suggested would be best:  just detect the condition and 
panic, with a string telling the user to use mem=xxx (we can figure that out) 
and/or upgrade their BIOS.

I'll spin a new patch to do that today.

Jesse
