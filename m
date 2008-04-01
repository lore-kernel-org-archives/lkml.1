Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYDABdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYDABdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 21:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYDABda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 21:33:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51588 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752018AbYDABd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 21:33:29 -0400
From: akepner@sgi.com
Date: Mon, 31 Mar 2008 18:31:59 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 v5] dma: add dma_*map*_attrs() interfaces
Message-ID: <20080401013159.GA29410@sgi.com>
References: <20080320010709.GN1843@sgi.com> <20080327201843.4f5f983b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327201843.4f5f983b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 08:18:43PM -0700, Andrew Morton wrote:
> On Wed, 19 Mar 2008 18:07:09 -0700 akepner@sgi.com wrote:
> 
> alpha allmodconfig:
> 
> 
> In file included from include/asm/pci.h:7,
>                  from include/linux/pci.h:953,
>                  from include/asm/core_mcpcia.h:9,
>                  from include/asm/io.h:226,
>                  from arch/alpha/kernel/asm-offsets.c:11:
> include/linux/dma-mapping.h: In function 'dma_map_single_attrs':
> include/linux/dma-mapping.h:157: error: implicit declaration of function 'pci_map_single'
> ....
> 
> We're in include hell, I think....

Yeah.

Alpha did some macro substitutions differently than on the 
other platforms I had built and tested with.

The simple fix is to convert the new _attrs()* functions 
in include/linux/dma-mapping.h into macros. 

An updated patch follows. Built for alpha, ia64, x86_64. 
Tested on ia64 and x86_64.

-- 
Arthur

