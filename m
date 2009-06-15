Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbZFOB4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbZFOB4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 21:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZFOB4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 21:56:38 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:37310 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZFOB4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 21:56:37 -0400
X-IronPort-AV: E=Sophos;i="4.42,219,1243828800"; 
   d="scan'208";a="93886"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: scripts/kallsyms: extending region checking for Blackfin memory regions
Date: Sun, 14 Jun 2009 21:59:42 -0400
User-Agent: KMail/1.9.5
CC: "Mike Frysinger" <vapier.adi@gmail.com>,
       kbuild-devel@lists.sourceforge.net,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "uclinux-dist-devel" <uclinux-dist-devel@blackfin.uclinux.org>
References: <8bd0f97a0906081623h4dc26492kd70c2e07091730d@mail.gmail.com> <20090614204437.GC3187@uranus.ravnborg.org>
In-Reply-To: <20090614204437.GC3187@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906142159.42280.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 15 Jun 2009 01:56:37.0043 (UTC) FILETIME=[84600830:01C9ED5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 14 Jun 2009 16:44, Sam Ravnborg pondered:
> On Mon, Jun 08, 2009 at 07:23:16PM -0400, Mike Frysinger wrote:
> > intro: the current Blackfin memory architecture is (1) no virtualized
> > memory and (2) distinctly harvard.  that means we cannot create a
> > linear map of start/end text sections.  we end up with distinct
> > regions like so:
> > 00001000 T __stext
> > 000dc4c0 T __etext
> > feb00000 A __etext_l2
> > feb00010 A __stext_l2
> > ffa00000 T __stext_l1
> > ffa0160c T __etext_l1
> > this is because external memory starts at address 0 while on-chip
> > regions have different discontiguous hardcoded addresses (L1
> > instruction in this case starts at 0xffa00000 while L2 starts at
> > 0xfeb00000).
> > 
> > the current kallsyms is written to search for the special stext/etext
> > symbols only which means the resulting kallsyms output knows nothing
> > of the Blackfin symbols living in these on-chip regions.  we've
> > written two patches to fix this: the first one is straight forward and
> > simply copies & pastes the existing hardcoded regions.  the second
> > creates an array of text regions which makes it much easier to extend
> > in the future for other people (and can be squashed into the first
> > one).
> > 
> > doesnt matter to me which method is picked :)
> 
> I added both as I liked the generalization.
> I had to rearrange the "Signed-off-by" in the first patch
> as this patch came in vai you and not Robin.

I think Mike pulled this from some work I did awhile ago, (and sent to you) 
that obviously never got added (since I didn't send it in the proper patch 
format).

http://lkml.indiana.edu/hypermail/linux/kernel/0607.1/0558.html

