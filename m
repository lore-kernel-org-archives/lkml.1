Return-Path: <linux-kernel-owner+w=401wt.eu-S2993096AbXCIJ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993096AbXCIJ76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637734AbXCIJ76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:59:58 -0500
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:22065 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993095AbXCIJ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:59:56 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Fri, 9 Mar 2007 10:57:10 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: discuss@x86-64.org, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] optimize and simplify get_cycles_sync()
Message-ID: <20070309095710.GB8922@amd.com>
References: <20070228140501.GA19452@amd.com>
 <20070228142554.GE19452@amd.com>
 <20070306162541.2b8a148d.akpm@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20070306162541.2b8a148d.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Mar 2007 09:57:56.0851 (UTC)
 FILETIME=[69A24430:01C76231]
X-WSS-ID: 69EFF04E328551529-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 04:25:41PM -0800, Andrew Morton wrote:
> On Wed, 28 Feb 2007 15:25:54 +0100
> "Joerg Roedel" <joerg.roedel@amd.com> wrote:
> 
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > This patch simplifies the get_cycles_sync() function by removing the
> > #ifdefs from it. Further it introduces an optimization for AMD
> > processors. There the RDTSCP instruction is used instead of CPUID;RDTSC
> > which is helpfull if the kernel runs as a KVM guest. Running as a guest
> > makes CPUID very expensive because it causes an intercept of the guest.
> 
> Problem:
> 
> http://test.kernel.org/functional/index.html
> 
> lots of builds fell over because their binutils versions don't understand
> rdtscp.
> 
> I don't know how recently rdtscp support was added to binutils, but
> this is likely to be a problem.  Perhaps we can change this patch to
> embed the hex code for that opcode instead?

Ok, I will submit an updated version soon. Thanks for pointing this out.

Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


