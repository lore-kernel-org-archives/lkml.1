Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYI3AiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYI3AiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYI3Ahx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:37:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYI3Ahw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:37:52 -0400
Message-ID: <48E173D2.1030708@zytor.com>
Date: Mon, 29 Sep 2008 17:33:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Alok Kataria <akataria@vmware.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>	 <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com>	 <48E1437D.7080606@zytor.com>  <48E1486C.3060306@goop.org> <1222730405.27056.237.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1222730405.27056.237.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> 
> Aren't we overthinking / overdesigning this a bit?  It's not rocke
> science.  We'd like to have a leaf set aside for TSC frequency, and
> maybe another leaf in the future.  We think other vendors might find a
> static clock frequency leaf to be useful, so if that happens to be the
> case, feel free to re-use the leaf.
> 

No, I don't think we are.  Under the circumstances I do not think 
anything other than positive identification is unacceptable.

If anything, the whole concept of reusing interfaces is what

> We don't expect to see lots of proliferation of CPU leaves at all, in
> fact, we'd be flummoxed to propose more than one right now.  So
> basically a nicely written comment section explaining how the SW CPUID
> registers are layed out is probably sufficient.  Other vendors can add
> to it as they see fit, and Linux itself can be the central standard
> body.  After all, it's what we all work on, and it makes sense for
> everyone here, even MS, to have the software leaves defined in a public
> work.

NIH is a huge factor, and MS is worse than most.

> The whole thing is software defined so it's not a big deal if one or all
> parties eventually don't play well with others, grow up to become
> bullies with ADD, or simply autistic children who ignore the whole
> thing.  You can always make detection vendor dependent when that
> happens.
> 
> Right now there's nothing shockingly vendor dependent, just a whole lot
> of complicated proposals about how to define what the bits are going to
> define and not enough bits of information to actually express.  It seems
> perfectly okay for now to have new leaf proposals defined by fiat for
> now.
> 
> As long as there is a vendor-ID leaf, nobody is blocking any forward
> progress by adding a new non-conflicting leaf.  We can always add the
> meta-leafs required for decoding if something tangible materializes, but
> for now the TSC leaf seems pretty useful and I would probably want to
> proclaim it by fatwa, if I had such a power.

If someone had the power to proclaim it by fatwa we wouldn't have much 
to worry about.  Intel might have the power, but we as a group in this 
thread definitely do not.

However, it is clear the virtualization industry doesn't have their act 
together to the point where one can rely on anything but positive 
identification, unlike in the hardware space, where we can rely on 
implicit identification, because people aren't stepping on each other's 
toes.

	-hpa
