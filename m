Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbYJJDA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbYJJDA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 23:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYJJDAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 23:00:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:37549 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYJJDAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 23:00:12 -0400
Date: Fri, 10 Oct 2008 11:59:35 +0900
To: yinghai@kernel.org
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081010113959U.fujita.tomonori@lab.ntt.co.jp>
References: <20081009211837.GC18444@colo.lackof.org>
	<48EE7745.2020603@kernel.org>
	<20081010113959U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081010115935M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 11:40:51 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 09 Oct 2008 14:27:33 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Grant Grundler wrote:
> > > On Wed, Oct 08, 2008 at 04:02:23PM -0700, Yinghai Lu wrote:
> > >> so can find out what is DMA mask is used for pci devices in addition to
> > >> default setting.
> > > 
> > > I like the idea. I don't like the additional boot time output.
> > > 
> > > But I'm thinking this could be an option to lspci.
> > > lspci already knows about the /sys tree. Can PCI export the two masks
> > > (dma_mask and dma_consistent_mask) and something like "lspci -td"
> > > would dump those in a nice way?
> > > 
> > in boot log, it could link with driver, pci info...
> > > 
> > >> got:
> > >> aacraid 0000:86:00.0: using 32bit DMA mask
> > >> aacraid 0000:86:00.0: using 32bit consistent DMA mask
> > >> aacraid 0000:86:00.0: using 64bit DMA mask
> > >> aacraid 0000:86:00.0: using 64bit consistent DMA mask
> > 
> > and aacraid do 32bit at first then 64bit...
> > 
> > so put that in boot message could be useful too.
> 
> IIRC, aacraid uses 32bit dma_mask at startup then it executes a
> special command to get dma information from the card, and sets proper
> dma_mask. So the above message is not wrong for aacraid, I think.

Oh, what you wanted to say is, "pci uses 32bit dma_mask and
dma_consistent_mask by default so aacraid doesn't need to set dma_mask
and dma_consistent_mask at startup", then it's true. You can remove
it. But it's just harmless unnecessary code.

But again, I don't think this is a good reason to print such dma
information for everyone at boot time.
