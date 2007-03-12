Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbXCLXTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbXCLXTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXCLXTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:19:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:48631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbXCLXTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:19:53 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ethan Solomita <solo@google.com>
Subject: Re: [PATCH 1/1] mm: Inconsistent use of node IDs
Date: Tue, 13 Mar 2007 00:19:30 +0100
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <45F5D974.2050702@google.com>
In-Reply-To: <45F5D974.2050702@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703130019.30953.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 23:51, Ethan Solomita wrote:
> This patch corrects inconsistent use of node numbers (variously "nid" or
> "node") in the presence of fake NUMA.

I think it's very consistent -- your patch would make it inconsistent though.

> Both AMD and Intel x86_64 discovery code will determine a CPU's physical
> node and use that node when calling numa_add_cpu() to associate that CPU
> with the node, but numa_add_cpu() treats the node argument as a fake
> node. This physical node may not exist within the fake nodespace, and
> even if it does, it will likely incorrectly associate a CPU with a fake
> memory node that may not share the same underlying physical NUMA node.
> 
> Similarly, the PCI code which determines the node of the PCI bus saves
> it in the pci_sysdata structure. This node then propagates down to other
> buses and devices which hang off the PCI bus, and is used to specify a
> node when allocating memory. The purpose is to provide NUMA locality,
> but the node is a physical node, and the memory allocation code expects
> a fake node argument.

Sorry, but when you ask for NUMA emulation you will get it. I don't see
any point in a "half way only for some subsystems I like" NUMA emulation. 
It's unlikely that your ideas of where it is useful and where is not
matches other NUMA emulation user's ideas too.

Besides adding such a secondary node space would be likely a huge long term 
mainteance issue. I just can it see breaking with every non trivial change.

NACK.

-Andi
