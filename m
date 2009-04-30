Return-Path: <linux-kernel-owner+w=401wt.eu-S1763791AbZD3Or4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763791AbZD3Or4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbZD3Orq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:47:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47674 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZD3Orp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:47:45 -0400
Date: Thu, 30 Apr 2009 10:48:04 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
       greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       Ben Woodard <woodard@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
Message-ID: <20090430144756.GA25200@redhat.com>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <87iqknp8a0.fsf@basil.nowhere.org> <20090430115741.GA23634@aftab> <20090430124716.GW23223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430124716.GW23223@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Ben Woodard, Mauro C. Chehab to Cc list)

> > Kconfig, mce code delivers needed error info to edac which, in turn,
> > goes and decodes the error/does the mapping to DIMM blocks/supplies DRAM
> > error injection facility for testing purposes and similar things. That
> > way you have both and they don't overlap in functionality.
> You can do that, but it's redundant because mcelog can do this
> this already. I had some conversations with existing EDAC users
> recently and they seem to only care about the resulting output,
> so just querying from mcelog is fine.
what about using the same EDAC interface? for lots of memory controllers, even
in other architectures than x86, EDAC interface is available. sounds
inconsistent to force users to have to handle special cases on their scripts
just because _optional_ sharing of error information from mce code is not
available.
how about SW/HW scrubbing?

> The only issue is that mcelog needs to get the DIMM data. In many
> cases it can do so from SMBIOS output, if not a suitable interface
> would need to be provided by the kernel.
that can be done already in EDAC and in this driver

> > By the way, I think there's a similar attempt/proposal of letting mce
> > and edac talk to each other from Red Hat so I think this could be a
> There was a fairly dubious patch floating around I think, but it
> had a couple of problems.
and what if those problems are solved? a patch like that would make possible
to have EDAC support for both AMD64 and Nehalem and wouldn't hurt the
performance of people who choose not to use EDAC.

-- 
Aristeu

