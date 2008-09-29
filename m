Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYI2XWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYI2XWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYI2XVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:21:54 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46706 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbYI2XVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:21:54 -0400
Subject: Re: Use CPUID to communicate with the hypervisor.
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       Alok Kataria <akataria@vmware.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <48E1486C.3060306@goop.org>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>
	 <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com>
	 <48E1437D.7080606@zytor.com>  <48E1486C.3060306@goop.org>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 16:20:05 -0700
Message-Id: <1222730405.27056.237.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-29 at 14:28 -0700, Jeremy Fitzhardinge wrote:
> > Unless there is a central authority assigning these, "we" can do all
> > we want, enough people will not pay attention.
> >
> > Basically, there needs to be a standards document that describes the
> > architecture, *and* needs to either have universal buy-in with all the
> > vendors or imposed by an authority with enough clout to do so (Intel
> > might.)
> ...

> I think using fixed offsets is unwise, since there's already contention
> for the same leaves.  Making sure that each block of leaves (where a
> block is 16, 256 or some other number of leaves) is self-describing via
> ABI signatures is the only sane way to go.  There's still the issue of

Aren't we overthinking / overdesigning this a bit?  It's not rocket
science.  We'd like to have a leaf set aside for TSC frequency, and
maybe another leaf in the future.  We think other vendors might find a
static clock frequency leaf to be useful, so if that happens to be the
case, feel free to re-use the leaf.

We don't expect to see lots of proliferation of CPU leaves at all, in
fact, we'd be flummoxed to propose more than one right now.  So
basically a nicely written comment section explaining how the SW CPUID
registers are layed out is probably sufficient.  Other vendors can add
to it as they see fit, and Linux itself can be the central standard
body.  After all, it's what we all work on, and it makes sense for
everyone here, even MS, to have the software leaves defined in a public
work.

The whole thing is software defined so it's not a big deal if one or all
parties eventually don't play well with others, grow up to become
bullies with ADD, or simply autistic children who ignore the whole
thing.  You can always make detection vendor dependent when that
happens.

Right now there's nothing shockingly vendor dependent, just a whole lot
of complicated proposals about how to define what the bits are going to
define and not enough bits of information to actually express.  It seems
perfectly okay for now to have new leaf proposals defined by fiat for
now.

As long as there is a vendor-ID leaf, nobody is blocking any forward
progress by adding a new non-conflicting leaf.  We can always add the
meta-leafs required for decoding if something tangible materializes, but
for now the TSC leaf seems pretty useful and I would probably want to
proclaim it by fatwa, if I had such a power.

Zach

