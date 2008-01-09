Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYAITMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYAITMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYAITL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:11:56 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46011 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbYAITLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:11:55 -0500
Subject: Re: [PATCH] x86_64: cleanup setup_node_zones called by paging_init
	v2
From: Dave Hansen <haveblue@us.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200801091030.40545.yinghai.lu@sun.com>
References: <200801081934.33964.yinghai.lu@sun.com>
	 <Pine.LNX.4.64.0801090947570.10163@schroedinger.engr.sgi.com>
	 <200801091030.40545.yinghai.lu@sun.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 11:11:40 -0800
Message-Id: <1199905900.9834.96.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 10:30 -0800, Yinghai Lu wrote:
> 
> [PATCH] x86_64: cleanup setup_node_zones called by paging_init v2
> 
> setup_node_zones calcuates some variable but only use them when
> FLAT_NODE_MEM_MAP is set
> 
> so change the MACRO postion to avoid calculating.
> 
> also change it to static 

I just see the patch adding a net of one #ifdef (and 3 lines of .c
file), and I don't consider that a cleanup. :(

If you make the function static, and make sure to cover that Dprintk up
with the #ifdef, I think the compiler should take care of the rest and
just throw away the function.  Then, you won't need to add the second
#ifdef.  You can even kill the brackets in that for loop.

Also, if you're going to be mucking around in there, can you give
setup_node_zones() a better name?  It doesn't exactly setup any zones
any more.  alloc_node_mem_map(), perhaps?  The comment above it is
bogus, too.

-- Dave

