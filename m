Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYJJFC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYJJFC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYJJFCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:02:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:53400 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbYJJFCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:02:49 -0400
Subject: Re: [PATCH v3] powerpc: properly reserve in bootmem the lmb
	reserved regions that cross NUMA nodes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adam Litke <agl@us.ibm.com>, Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <48EE6720.6010601@linux.vnet.ibm.com>
References: <48EE6720.6010601@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 15:55:16 +1100
Message-Id: <1223614516.8157.154.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 15:18 -0500, Jon Tollefson wrote:
> If there are multiple reserved memory blocks via lmb_reserve() that are
> contiguous addresses and on different NUMA nodes we are losing track of which 
> address ranges to reserve in bootmem on which node.  I discovered this 
> when I recently got to try 16GB huge pages on a system with more then 2 nodes.

I'm going to apply it, however, could you double check something for
me ? A cursory glance of the new version makes me wonder, what if the
first call to get_node_active_region() ends up with the work_fn never
hitting the if () case ? I think in that case, node_ar->end_pfn never
gets initialized right ? Can that happen in practice ? I suspect that
isn't the case but better safe than sorry...

If there's indeed a potential problem, please send a fixup patch.

Cheers,
Ben.


