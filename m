Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbXFDPyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbXFDPyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbXFDPyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:54:24 -0400
Received: from outbound-mail-56.bluehost.com ([69.89.20.36]:50264 "HELO
	outbound-mail-56.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753893AbXFDPyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:54:23 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Mon, 4 Jun 2007 08:54:07 -0700
User-Agent: KMail/1.9.6
Cc: "Matt Keenan" <tank.en.mate@gmail.com>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706040840.21593.jbarnes@virtuousgeek.org> <2c0942db0706040848y1d1c2ce9p521c65117244edf1@mail.gmail.com>
In-Reply-To: <2c0942db0706040848y1d1c2ce9p521c65117244edf1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706040854.07712.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 4, 2007 8:48:37 Ray Lee wrote:
> On 6/4/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Sunday, June 3, 2007 2:15:06 Matt Keenan wrote:
> > > Justin Piszcz wrote:
> > > > On Sat, 2 Jun 2007, Andi Kleen wrote:
> > > >>> I feel, having a silent/transparent workaround is not a good idea.
> > > >>> With that
> > > >>
> > > >> If enough RAM is chopped off users will notice. They tend to
> > > >> complain when they miss RAM.  I don't like panic very much because
> > > >> for many users it will be a show stopper (even when they are not
> > > >> blessed with "quiet" boots like some distributions do)
> > > >>
> > > >> The message in dmesg could be also emphasized a bit with a little
> > > >> ASCII art (but no <blink> tag in there)
> > > >>
> > > >> The problem I'm more worried about is if the system will be really
> > > >> stable --- could it be that the memory controller is still
> > > >> misconfigured and cause other stability issues? (we've had such
> > > >> cases in the past). Also I'm not sure we can handle the case of
> > > >> the MTRR wrong not at the end of memory but at the hole sanely.
> > > >>
> > > >> -Andi
> > > >
> > > > So far I have been booting with mem=8832M and have run stress/loaded
> > > > the memory subsystem pretty good; what other tests should I run?
> > > >
> > > > It'd be nice if we could pose some sort of solution/warning for the
> > > > future so other people do not have to experience the same problems.
> > > >
> > > > What are the next steps?
> > >
> > > Wouldn't it be possible for the e820/MTRR set up code detect the
> > > problem and suggest a mem=xxxx that would fix the problem (while also
> > > complaining that the BIOS is broken)?
> >
> > Yes, that should be fairly easy, though as Andi points out, if there are
> > holes in the MTRR setup, things get a little trickier (I had an earlier
> > patch to deal with this, but ended up with too many early boot issues).
> >
> > Maybe what Venki suggested would be best:  just detect the condition and
> > panic, with a string telling the user to use mem=xxx (we can figure that
> > out) and/or upgrade their BIOS.
>
> Ick. Systems that used to boot fine would then panic on a kernel
> upgrade. That's rather rude for a condition that's merely an
> optimization (using all memory), rather than one of correctness. A
> panic seems entirely inappropriate.

No, existing kernels would have been so slow as to be nearly unusable on 
machines with this problem.  Reducing the amount of available memory 
automatically might work in most cases, but as Venki pointed out, people will 
have to check their logs to notice that anything is wrong.

But I don't have a strong preference, maybe just a boot time message (with 
suitably obnoxious ascii art) would be sufficient.

Jesse
