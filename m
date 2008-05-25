Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYEYHU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYEYHU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 03:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbYEYHUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 03:20:16 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:26872 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYEYHUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 03:20:15 -0400
Date: Sun, 25 May 2008 10:20:11 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Amit Shah <amit.shah@qumranet.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com, andi@firstfloor.org, kvm@vger.kernel.org,
       avi@qumranet.com
Subject: Re: [PATCH v2 -mm 0/2] x86: per-device dma_mapping_ops
Message-ID: <20080525072011.GM7334@il.ibm.com>
References: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <200805221613.03686.amit.shah@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805221613.03686.amit.shah@qumranet.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 04:13:02PM +0530, Amit Shah wrote:

> OK; this sounds helpful. the hook can make a hypercall and confirm
> with the host kernel if the device in question is an assigned
> physical device. If yes, we replace the dma_ops. Though, the
> original intent of having stackable ops is that we might want to go
> through the swiotlb in the guest even for an assigned device if the
> guest dma addresses are not in the addressable range of the guest
> chipset.
> 
> > created (it works with hot plugging). It enables IOMMUs to set up an
> > appropriate dma_mapping_ops per device.
> 
> From what we've discussed so far, it looks like stackable dma ops will 
> definitely be needed. Does this patchset provide something that stacking 
> won't?

Yes---this patchset let's you have a per-device dma-ops, whereas with
stackable you only get global dma-ops. I think it's clear we need
both, and I think per-device dma-ops are the first thing that's
needed. Stacking can then be introduced on a per-device basis.

Cheers,
Muli

