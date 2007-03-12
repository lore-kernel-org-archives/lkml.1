Return-Path: <linux-kernel-owner+w=401wt.eu-S1030525AbXCLQ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525AbXCLQ0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXCLQ0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:26:16 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:35134 "EHLO
	mail121-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030525AbXCLQ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:26:15 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 12 Mar 2007 17:24:05 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@argo.co.il>
cc: discuss@x86-64.org, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 TRY#3] optimize and simplify get_cycles_sync()
Message-ID: <20070312162405.GA21463@amd.com>
References: <20070309150825.GA13481@amd.com>
 <20070309151511.GE13481@amd.com> <45F1A2FB.7040206@argo.co.il>
 <20070312130245.GE8922@amd.com> <45F57AEB.5030405@argo.co.il>
MIME-Version: 1.0
In-Reply-To: <45F57AEB.5030405@argo.co.il>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 12 Mar 2007 16:25:44.0535 (UTC)
 FILETIME=[157E5670:01C764C3]
X-WSS-ID: 69EBA086328788901-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 06:08:11PM +0200, Avi Kivity wrote:
> Joerg Roedel wrote:
> >On Fri, Mar 09, 2007 at 08:10:03PM +0200, Avi Kivity wrote:
> >  
> >>Joerg Roedel wrote:
> >>    
> >>>From: Joerg Roedel <joerg.roedel@amd.com>
> >>>
> >>>This patch simplifies the get_cycles_sync() function by removing
> >>>the #ifdefs from it. Further it introduces an optimization for AMD
> >>>processors. There the RDTSCP instruction is used instead of CPUID;RDTSC
> >>>which is helpfull if the kernel runs as a KVM guest. Running as a guest
> >>>makes CPUID very expensive because it causes an intercept of the guest.
> >>>
> >>> +#define RDTSCP ".byte 0x0f, 0x01, 0xf9"
> >>>+	alternative_io_two("cpuid\nrdtsc",
> >>>+			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
> >>>+			   ".byte 0x0f, 0x01, 0xf9", X86_FEATURE_RDTSCP,
> >>>       
> >>why not use the RDTSCP macro here?
> >>    
> >
> >Does this macro exist? I couldn't found it in the current git tree. And
> >the rdtscp macros in msr.h use the plain opcode too.
> >  
> 
> -ENOCOFFEE?  You defined the macro 3 lines above the .byte directive...

Yes, lack of coffee, and even worse -EBLINDHACKER :-(

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


