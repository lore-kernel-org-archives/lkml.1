Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbXITGeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbXITGeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbXITGem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:34:42 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:19800 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbXITGel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:34:41 -0400
X-IronPort-AV: i="4.20,276,1186372800"; 
   d="scan'208"; a="39964057:sNHT34055448"
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin
	relocations
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Robin Getz <rgetz@blackfin.uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       David McCullough <David_Mccullough@securecomputing.com>,
       uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       Bernd Schmidt <bernd.schmidt@analog.com>,
       Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       linux-m32r@ml.linux-m32r.org
In-Reply-To: <200709200208.29580.rgetz@blackfin.uclinux.org>
References: <1190102965.4406.9.camel@roc-desktop>
	 <8bd0f97a0709192042g67f13337nf62978768b64ff80@mail.gmail.com>
	 <20070920035412.GA31501@linux-sh.org>
	 <200709200208.29580.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 20 Sep 2007 14:34:36 +0800
Message-Id: <1190270076.10133.16.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 20 Sep 2007 06:34:39.0580 (UTC) FILETIME=[520BA9C0:01C7FB50]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 02:08 -0400, Robin Getz wrote:
> On Wed 19 Sep 2007 23:54, Paul Mundt pondered:
> > On Wed, Sep 19, 2007 at 11:42:53PM -0400, Mike Frysinger wrote:
> > > On 9/19/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > > > On Thu, Sep 20, 2007 at 11:55:25AM +1000, David McCullough wrote:
> > > > > Jivin Robin Getz lays it down ...
> > > > > > On Tue 18 Sep 2007 04:09, Bryan Wu pondered:
> > > > > > > This just adds minimum support for the Blackfin relocations,
> > > > > > > since we don't have enough space in each reloc. The idea
> > > > > > > is to store a value with one relocation so that subsequent 
> > > > > > > ones can  access it.
> > > > > >
> > > > > > Adding the other appropriate maintainers. for h8, m32r, sh and
> > > > > > v850. 
> > > > >
> > > > > Looks fine to me,  obviously impacts the existing arches very
> > > > > little.  Can't see why it shouldn't get included,
> > > >
> > > > I find it a bit disconcerting that blackfin already depends on this
> > > > in-tree without there being any earlier discussion on making these
> > > > changes.
> > > 
> > > not really ... this patch was posted before but was lost in the
> > > shuffle ... and i'm not quite sure what you mean by "depends on" ...
> > > if you want to use the FLAT file format on a Blackfin processor, then
> > > this patch is needed, but that isnt the only file format that works on
> > > the Blackfin port as we also have FDPIC ELF
> > > 
> > What I mean by "depends on" is that for what you are attempting to
> > patch, your architecture has an in-tree dependency on something that hasn't
> > been discussed.
> 
> "not been discussed" because it was sent to lkml -
> http://lkml.org/lkml/2006/9/22/60
> - and it got missed/left on the floor during the arch/blackfin inclusion 
> (which was huge), not because of any deliberate malicious intent on our part 
> to mislead or try to get this in now by doing an end around as you are 
> implying.
> 

Yes, as Robin pointed out, this patch was sent to LKML at least 3 times
including Bernd's email. This is the 4th round.
http://lkml.org/lkml/2007/5/29/24
http://lkml.org/lkml/2007/5/28/63

I don't wanna to resend it again and again to annoy the receiver and
LKML. But IMO, technically this patch looks fine to binfmt_flat and
other architectures. And the in-tree Blackfin port will fail to be
compiled with this patch if the BINFMT_FLAT is enabled.

> Our mistake for not poking everyone/resending things sooner/before 
> arch/blackfin was included. Bryan will try to make sure that doesn't happen 
> again (right Bryan?) - like he is now, by poking/resending things, and making 
> sure that the appropriate maintainers (like you, if we are changing things 
> you maintain) are included. (which is what I think the problem was).
> 
> If we can focus on the technical merits of things, rather than how we got 
> here - which I agree sucks - was our mistake - we are sorry - we will try to 
> make sure that it doesn't happen again - I think it would be time/effort 
> better spent.
> 

Yes, I will try my best to avoid this happen again. But on the other
hand, several reasons made this mess happen:
a) not very easy found the maintainer information for several domain,
for example this patch should invite binfmt_flat maintainers, arch
maintainers (Thanks Robin to invite them), blackfin port maintainers and
toolchain maintainers.
b) even the maintainers got this patch email, they don't have time to
review or reply. So the patch was ignored by LKML and the sender, sorry
-:))).
c) There is a rule that do __NOT__ send the same patch again and again,
I don't wanna to break this rule. But if there is no feedback about the
patch, we have no choice but resent it or just ignore it.

I know it is general problem in the LKML patch review.

Thanks
-Bryan
