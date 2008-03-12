Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYCLGWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYCLGWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 02:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYCLGWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 02:22:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52990 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751882AbYCLGWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 02:22:43 -0400
Date: Tue, 11 Mar 2008 23:21:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 2/3] slab: introduce SMP alignment
In-Reply-To: <20080311071330.GA20271@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803112316090.4794@schroedinger.engr.sgi.com>
References: <20080303200355.GB8974@wotan.suse.de>
 <Pine.LNX.4.64.0803031208400.16049@schroedinger.engr.sgi.com>
 <20080303201211.GE8974@wotan.suse.de> <Pine.LNX.4.64.0803031216430.3110@schroedinger.engr.sgi.com>
 <20080303202411.GH8974@wotan.suse.de> <Pine.LNX.4.64.0803031327330.4375@schroedinger.engr.sgi.com>
 <20080307043700.GI21185@wotan.suse.de> <Pine.LNX.4.64.0803062108210.1143@schroedinger.engr.sgi.com>
 <20080307051944.GJ21185@wotan.suse.de> <Pine.LNX.4.64.0803062120410.1215@schroedinger.engr.sgi.com>
 <20080311071330.GA20271@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Nick Piggin wrote:

> On Thu, Mar 06, 2008 at 09:26:24PM -0800, Christoph Lameter wrote:
> > Internode alignment is 4k. If you need an object aligned like that then it 
> > may be better to go to the page allocator.
> 
> I never got a reply about this. Again: how can the modern slab allocator
> avoid the need for internode alignment in order to prevent cacheline
> pingpong on vsmp? Because I'm going to resubmit the SMP_ALIGN patch.

You quoted my answer. Use the page allocator to allocate data that has an 
alignment requirement on a 4k boundary.

> Also, the last I heard about the HWCACHE_ALIGN from you is that it didn't
> make sense... I see it's merged now, which I appreciate, but I think it is
> really important that we're on the same page here, so let me know if it
> still doesn't make sense.

I still think that the semantics are weird because it only works sometimes 
and then performs an alignment within a cacheline that improves the 
situation somewhat in some cases but does not give the user what he 
expected.
