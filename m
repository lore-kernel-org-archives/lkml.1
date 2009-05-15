Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbZEOMIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbZEOMIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZEOMH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:07:58 -0400
Received: from thunk.org ([69.25.196.29]:57322 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZEOMH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:07:57 -0400
Date: Fri, 15 May 2009 08:07:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: James Morris <jmorris@namei.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>,
       John Gilmore <gnu@toad.com>
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090515120748.GF6816@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Cihula, Joseph" <joseph.cihula@intel.com>,
	James Morris <jmorris@namei.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"arjan@linux.intel.com" <arjan@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"andi@firstfloor.org" <andi@firstfloor.org>,
	"chrisw@sous-sol.org" <chrisw@sous-sol.org>,
	"jbeulich@novell.com" <jbeulich@novell.com>,
	"peterm@redhat.com" <peterm@redhat.com>,
	"Wei, Gang" <gang.wei@intel.com>,
	"Wang, Shane" <shane.wang@intel.com>, John Gilmore <gnu@toad.com>
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu> <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org> <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 06:45:29PM -0700, Cihula, Joseph wrote:
> 
> For a balanced view on Trusted Computing, people should also read
> David Safford's (IBM) rebuttal whitepaper at:
> http://www.research.ibm.com/gsal/tcpa/tcpa_rebuttal.pdf.

Note that most of what David wrote about in his paper was specific to
TCPA, and not necessarily the TXT/LaGrande technology.  I recently
defended TCPA to someone who expressed concerns about IMA going into
the kernel, on the grounds that TCPA was so badly done it was almost
impossible to use it to create a workable DRM system.  Given how TCPA
works, this is definitely true, and I judge that the benefits (being
able to protect private keys under the user's controlled) outwieghs
the potential downsides (namely that of DRM, given that it was pretty
much impossible to make a workable DRM system using the TCPA/IMA
architecture alone).

However, it seems to me that TXT/LaGrande's main purpose for existence
was to repair the defects in TCPA that made it essentially unsuable
for DRM purposes.  With TCPA, any time you changed *anything* in the
boot path --- installed a new BIOS, upgraded to a new kernel to fix a
security vulnerability, updated to a new Nvidia proprietary video
driver slightly less likely to crash your sustem --- it would change
the trusted boot measurements, and would require an exchange to
"Circuity City DIVX hotline" (as a generic stand-in for whoever is
Hollywood's current monkey paw towards trying to implement DRM) to
approve a transfer of the TCPA trusted keys, which would be
essentially be a consumer support nightmare, and there would be no way
for "Circuit City" to know whether the kernel you are claiming was the
latest update from Fedora or Novell or Canonical was really an
authorized upgrade, or whether it was a custom kernel with patches to
tap into video and audio paths to steal Hollywood's precious bodily
fluids.

With TXT, however, all of these problems go away.  What you end up
booting is completely under "Circit City's DIVX's" control, and may
include a miniature Windows environment running in the trusted
environment; it could then take over a portion of the screen for the
video output, and the hardware would have special features set up to
prevent the host OS from having any access to the video output of the
movie player running in the TXT environment.  (This was how Intel
presented the LaGrande technology to the Kernel Summit several years
ago, and I assume the capabilities of TXT hasn't change significantly
since then.)

Essentially, it's hard for me to think up situations where the TCPA
chip would not be sufficient in terms of being a solution to a
security problem that has the user's best interests at heart, rather
than that of Hollywood, and where TXT would be a such a solution.
Medical records are perhaps the best example I can come up with; and
maybe some kind of bank security system where you're only allowed to
engage in on-line banking if you run a bank-supplied application in
the TXT environment.  However, it's hard for me to believe banks and
hospitals will invest in solutions that implement these sorts of
benign solutions, and it's all too easy for me to believe that
Hollywood will invest in these sorts of solutions.

That being said, it's not clear to me that stopping the technology
from going into Linux really isn't going to help matters;
realistically, the Linux desktop is miniscule[1], and whether or not
we add support for TXT in the mainline Linux kernel isn't going to
stop Hollywood's plans.  A much better approach would be for the FSF
to organize a boycott urging users users not to buy *any* hardware
that is TXT enabled, whether it is going to be booting Windows, MacOS
X, or Linux.  And note that I said *hardware*, not CPU.  In order for
TXT to work, the BIOS, motherboard, video chipset, etc., all have to
be working in concert in order to provide a secure environment that
can't be tapped in by the Host OS.

[1] The one potential risk I could see is TXT being used in Moblin,
and that being used as a scheme to implement DRM ala Hollywood style.
But realistically, even if we don't let it into mainline kernel, it
won't stop Moblin hardware vendors from shipping it.

The bottom line is it this is a social problem, not a technical
problem, and probably needs to be solved by social means (i.e., an
FSF-led boycott).  But from a technical point of view, I would be
shocked if the first major user of the TXT technology *wasn't* to
provide DRM enforcement of one kind or another.

Regards,

						- Ted
