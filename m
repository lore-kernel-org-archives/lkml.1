Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbYCURmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbYCURmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbYCURlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:41:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48220 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760061AbYCURlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:41:50 -0400
Date: Fri, 21 Mar 2008 10:40:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
In-Reply-To: <20080321.002502.223136918.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061726.782068299@sgi.com>
 <20080321.002502.223136918.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, David Miller wrote:

> I would be very careful with this especially on IA64.
> 
> If the TLB miss or other low-level trap handler depends upon being
> able to dereference thread info, task struct, or kernel stack stuff
> without causing a fault outside of the linear PAGE_OFFSET area, this
> patch will cause problems.

Hmmm. Does not sound good for arches that cannot handle TLB misses in 
hardware. I wonder how arch specific this is? Last time around I was told 
that some arches already virtually map their stacks.

