Return-Path: <linux-kernel-owner+w=401wt.eu-S965522AbXCLNXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbXCLNXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965411AbXCLNXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:23:46 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:10774 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965522AbXCLNXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:23:45 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 12 Mar 2007 14:21:55 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: discuss@x86-64.org, "Avi Kivity" <avi@argo.co.il>,
       linux-kernel@vger.kernel.org
Subject: Re: [discuss] [PATCH 4/4 TRY#3] optimize and simplify
 get_cycles_sync()
Message-ID: <20070312132155.GF8922@amd.com>
References: <20070309150825.GA13481@amd.com>
 <45F1A2FB.7040206@argo.co.il> <20070312130245.GE8922@amd.com>
 <200703121409.18533.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200703121409.18533.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 12 Mar 2007 13:23:33.0114 (UTC)
 FILETIME=[A1DBDDA0:01C764A9]
X-WSS-ID: 69EB8BD2328770167-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 02:09:18PM +0100, Andi Kleen wrote:
> On Monday 12 March 2007 14:02, Joerg Roedel wrote:
> > On Fri, Mar 09, 2007 at 08:10:03PM +0200, Avi Kivity wrote:
> > > Joerg Roedel wrote:
> > > >From: Joerg Roedel <joerg.roedel@amd.com>
> > > >
> > > >This patch simplifies the get_cycles_sync() function by removing
> > > >the #ifdefs from it. Further it introduces an optimization for AMD
> > > >processors. There the RDTSCP instruction is used instead of CPUID;RDTSC
> > > >which is helpfull if the kernel runs as a KVM guest. Running as a guest
> > > >makes CPUID very expensive because it causes an intercept of the guest.
> > > >
> > > >  +#define RDTSCP ".byte 0x0f, 0x01, 0xf9"
> > > >+	alternative_io_two("cpuid\nrdtsc",
> > > >+			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
> > > >+			   ".byte 0x0f, 0x01, 0xf9", X86_FEATURE_RDTSCP,
> > > >  
> > > 
> > > why not use the RDTSCP macro here?
> > 
> > Does this macro exist? I couldn't found it in the current git tree. And
> > the rdtscp macros in msr.h use the plain opcode too.
> 
> It doesn't exist. The rdtscp macros are also not used currently, that
> is why nobody's binutils complained.
> 
> Doing the .bytes is ok
> 
> I still don't like the alternative() record complications though.

Do you think of another way to make use of RDTSCP in the get_cycles_sync
function? Using CPUID in a function called such often is bad when
running Linux as a  virtualization guest...
So using RDTSCP there might be a goog idea.

Regards,
Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


