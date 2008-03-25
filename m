Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYCYRoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYCYRoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbYCYRoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:44:14 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46998 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753387AbYCYRoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:44:13 -0400
Date: Tue, 25 Mar 2008 10:42:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: David Miller <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: RE: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE5B84D@orsmsx424.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0803251036410.15870@schroedinger.engr.sgi.com>
References: <20080321061726.782068299@sgi.com> <20080321.002502.223136918.davem@davemloft.net>
 <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
 <20080321.145712.198736315.davem@davemloft.net>
 <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
 <1FE6DD409037234FAB833C420AA843ECE5B84D@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008, Luck, Tony wrote:

> > I am familiar with that area and I am resonably sure that this 
> > is an issue on IA64 under some conditions (the processor decides to spill 
> > some registers either onto the stack or into the register backing store 
> > during tlb processing). Recursion (in the kernel context) still expects 
> > the stack and register backing store to be available. ccing linux-ia64 for 
> > any thoughts to the contrary.
> 
> Christoph is correct ... IA64 pins the TLB entry for the kernel stack
> (which covers both the normal C stack and the register backing store)
> so that it won't have to deal with a TLB miss on the stack while handling
> another TLB miss.

I thought the only pinned TLB entry was for the per cpu area? How does it 
pin the TLB? The expectation is that a single TLB covers the complete 
stack area? Is that a feature of fault handling?

