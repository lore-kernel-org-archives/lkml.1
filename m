Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZFOEfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZFOEfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZFOEe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:34:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50573 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZFOEe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:34:59 -0400
Date: Mon, 15 Jun 2009 06:37:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       kbuild-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [kbuild-devel] scripts/kallsyms: extending region checking for Blackfin memory regions
Message-ID: <20090615043716.GA9900@uranus.ravnborg.org>
References: <8bd0f97a0906081623h4dc26492kd70c2e07091730d@mail.gmail.com> <20090614204437.GC3187@uranus.ravnborg.org> <200906142159.42280.rgetz@blackfin.uclinux.org> <8bd0f97a0906141905m54958c02l3cae598d0136980b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906141905m54958c02l3cae598d0136980b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 10:05:26PM -0400, Mike Frysinger wrote:
> On Sun, Jun 14, 2009 at 21:59, Robin Getz wrote:
> > On Sun 14 Jun 2009 16:44, Sam Ravnborg pondered:
> >> On Mon, Jun 08, 2009 at 07:23:16PM -0400, Mike Frysinger wrote:
> >> > intro: the current Blackfin memory architecture is (1) no virtualized
> >> > memory and (2) distinctly harvard.  that means we cannot create a
> >> > linear map of start/end text sections.  we end up with distinct
> >> > regions like so:
> >> > 00001000 T __stext
> >> > 000dc4c0 T __etext
> >> > feb00000 A __etext_l2
> >> > feb00010 A __stext_l2
> >> > ffa00000 T __stext_l1
> >> > ffa0160c T __etext_l1
> >> > this is because external memory starts at address 0 while on-chip
> >> > regions have different discontiguous hardcoded addresses (L1
> >> > instruction in this case starts at 0xffa00000 while L2 starts at
> >> > 0xfeb00000).
> >> >
> >> > the current kallsyms is written to search for the special stext/etext
> >> > symbols only which means the resulting kallsyms output knows nothing
> >> > of the Blackfin symbols living in these on-chip regions.  we've
> >> > written two patches to fix this: the first one is straight forward and
> >> > simply copies & pastes the existing hardcoded regions.  the second
> >> > creates an array of text regions which makes it much easier to extend
> >> > in the future for other people (and can be squashed into the first
> >> > one).
> >> >
> >> > doesnt matter to me which method is picked :)
> >>
> >> I added both as I liked the generalization.
> >> I had to rearrange the "Signed-off-by" in the first patch
> >> as this patch came in vai you and not Robin.
> >
> > I think Mike pulled this from some work I did awhile ago, (and sent to you)
> > that obviously never got added (since I didn't send it in the proper patch
> > format).
> >
> > http://lkml.indiana.edu/hypermail/linux/kernel/0607.1/0558.html
> 
> yeah, the first patch was by Robin ... the "From:" line in the patch
> should have shown that (and git-am would have respected) ...

So does the patch.
What I had to change was that the Signed-off-by: lines indicated
that this patch came in like this:

Robin -> Mike -> Bryan Wu -> Sam
So I rearranged the signed-off-by: lines so it indicated
the following order:

Robin -> Bryan Wu -> Mike -> Sam


I trust that Bryan really did add his sob, and it
was only a mistake that Mike added his sob before
that of Bryans.

	Sam
