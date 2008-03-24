Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbYCXS3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbYCXS3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbYCXS27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:28:59 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38948 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753694AbYCXS26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:28:58 -0400
Date: Mon, 24 Mar 2008 11:27:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
In-Reply-To: <20080321.145712.198736315.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
References: <20080321061726.782068299@sgi.com> <20080321.002502.223136918.davem@davemloft.net>
 <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
 <20080321.145712.198736315.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, David Miller wrote:

> The thing to do is to first validate the way that IA64
> handles recursive TLB misses occuring during an initial
> TLB miss, and if there are any limitations therein.

I am familiar with that area and I am resonably sure that this 
is an issue on IA64 under some conditions (the processor decides to spill 
some registers either onto the stack or into the register backing store 
during tlb processing). Recursion (in the kernel context) still expects 
the stack and register backing store to be available. ccing linux-ia64 for 
any thoughts to the contrary.

The move to 64k page size on IA64 is another way that this issue can be 
addressed though. So I think its best to drop the IA64 portion.
