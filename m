Return-Path: <linux-kernel-owner+w=401wt.eu-S965842AbXCLNJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965842AbXCLNJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965845AbXCLNJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:09:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965842AbXCLNJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:09:31 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] [PATCH 4/4 TRY#3] optimize and simplify get_cycles_sync()
Date: Mon, 12 Mar 2007 14:09:18 +0100
User-Agent: KMail/1.9.5
Cc: "Joerg Roedel" <joerg.roedel@amd.com>, "Avi Kivity" <avi@argo.co.il>,
       linux-kernel@vger.kernel.org
References: <20070309150825.GA13481@amd.com> <45F1A2FB.7040206@argo.co.il> <20070312130245.GE8922@amd.com>
In-Reply-To: <20070312130245.GE8922@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121409.18533.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 14:02, Joerg Roedel wrote:
> On Fri, Mar 09, 2007 at 08:10:03PM +0200, Avi Kivity wrote:
> > Joerg Roedel wrote:
> > >From: Joerg Roedel <joerg.roedel@amd.com>
> > >
> > >This patch simplifies the get_cycles_sync() function by removing
> > >the #ifdefs from it. Further it introduces an optimization for AMD
> > >processors. There the RDTSCP instruction is used instead of CPUID;RDTSC
> > >which is helpfull if the kernel runs as a KVM guest. Running as a guest
> > >makes CPUID very expensive because it causes an intercept of the guest.
> > >
> > >  +#define RDTSCP ".byte 0x0f, 0x01, 0xf9"
> > >+	alternative_io_two("cpuid\nrdtsc",
> > >+			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
> > >+			   ".byte 0x0f, 0x01, 0xf9", X86_FEATURE_RDTSCP,
> > >  
> > 
> > why not use the RDTSCP macro here?
> 
> Does this macro exist? I couldn't found it in the current git tree. And
> the rdtscp macros in msr.h use the plain opcode too.

It doesn't exist. The rdtscp macros are also not used currently, that
is why nobody's binutils complained.

Doing the .bytes is ok

I still don't like the alternative() record complications though.

-Andi
