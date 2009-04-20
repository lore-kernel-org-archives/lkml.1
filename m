Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbZDTQ7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbZDTQ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 12:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZDTQ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 12:59:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36219 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbZDTQ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 12:59:40 -0400
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090419233518.GA765@elte.hu>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
	 <20090414165722.GD2089@elte.hu> <20090414180832.GA25692@elte.hu>
	 <49E79B1E.9090405@garzik.org>  <20090419233518.GA765@elte.hu>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 16:59:37 +0000
Message-Id: <1240246777.3315.42.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 01:35 +0200, Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
> > Ingo Molnar wrote:
> >> * Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >>> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >>>
> >>>>  39 files changed, 554 insertions(+), 726 deletions(-)
> >>> That diffstat is not against current mainline, is it? Would you mind 
> >>> to send a proper diffstat with the revert included as well? That will 
> >>> give us a complete picture.
> >>
> >> ok, i did the calculations, and the effect of adding back x86/Voyager 
> >> is roughly:
> >>
> >>    48 files changed, 5226 insertions(+), 142 deletions(-)
> >>
> >> That's quite a lot, and lets put this into perspective.
> >>
> >> You are talking about moving ~5000 lines of legacy code back into  
> >> arch/x86/, for a total of *four* Voyager/Linux systems, which are  
> >> using _ancient_ 486/P5 era CPUs.
> >>
> >> Two of these systems are in your house, two are somewhere unknown:  
> >> their owners certainly never sent bugreports against recent mainline  
> >> kernels (Voyager didnt even _build_ for a couple of straight kernel  
> >> releases), and i suspect those boxes are probably decommissioned  
> >> already.
> >>
> >> A single core on my run-of-the-mill x86 laptop has more computing  
> >> power than all Voyager/Linux systems on the planet, combined. And you 
> >> now want to add back support to the mainline arch/x86 code, which we 
> >> are trying hard to keep running on millions of x86 Linux systems?
> >>
> >> You still have not given proper justification for doing that ...
> >>
> >> Sorry to be the one to say 'no', but the reasons you gave so far were 
> >> not very convincing to me.
> >>  Anyway, you seem to be willing to maintain this code it out of tree.  
> >> If someone owns such an ancient Voyager box and wants to test a new  
> >> kernel then your tree is a good starting point for doing that. There's 
> >> really no pressing need to have this in mainline.
> >
> > That argument is more than a little unfair, Ingo.  Voyager support 
> > used to be in mainline.
> 
> The last time it built fine upstream was v2.6.26.0. After that:
> 
>   v2.6.27.0:   Voyager was broken - it did not even build.
>   v2.6.28.0:   Voyager was broken - it did not even build.
>   v2.6.29-rc5: Voyager was broken - it did not even build.
> 
> ... which was the point when we yanked it from the x86 devel tree.
> 
> ... at which time (after i Cc:-ed James Bottomley on the yanking) he 
> sent us the fix which we pulled - so v2.6.29 finally built. (But 
> even up to v2.6.27 Voyager was a rocky road - with regressions and 
> late fixes.)
> 
> Anyway, that long window of breakage has really proven the most 
> important fact: that no user really cares about x86/Voyager anymore.

That's an interesting economy with the truth.

You had a patch fixing the 2.6.27 breakage about 20 days after the
kernel released and the problem was discovered.  The evidence is here:

http://marc.info/?t=122540077200005

You just sat on the patch and failed to apply it ... until about three
months later you decided you didn't like it ... presumably because you
were trying to remove the subarchitectures upon which voyager is built.

The reason 2.6.28 didn't build was because you still wouldn't apply the
patches.

It's a bit difficult to square this and other fairly lengthy sets of
email exchanges over voyager and the phrase "no user really cares about
voyager"

James


