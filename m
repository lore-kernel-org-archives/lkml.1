Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbXJYGmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbXJYGmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbXJYGmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:42:14 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:37792 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbXJYGmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:42:14 -0400
Date: Thu, 25 Oct 2007 07:40:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc1] fix sg_phys to use dma_addr_t
In-Reply-To: <20071024192949.346687ed@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0710250730260.9811@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0710241957240.4733@blonde.wat.veritas.com>
 <20071024192949.346687ed@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Arjan van de Ven wrote:
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > ---
> > Whether this is a complete patch, suitable for all architectures,
> > I'm not sure: it builds, boots and runs correctly on the x86_32 box
> > in question, but you'll be a lot wiser than me about using dma_addr_t
> > for everyone.  (Seems a bit of a shame to include <asm/types.h> here,
> > when I think all arches already get to include it one way or another,
> > typically via asm/scatterlist.h; but I guess it's safest to repeat
> > it.)
> 
> there is a problem with this... sg_phys doesn't return an actual *dma*
> address.... at least not an address you can give to the device.
> Using dma_addr_t is thus a bit misleading.....

True.  Perhaps sg_phys() should use its own sg_phys_addr_t, defined
or typedefed to be the same as dma_addr_t.  But would this inline
function then be the only place in the tree which uses that type?
If so, then it'd probably be better just to let sg_phys() carry on
using dma_addr_t, but insert a comment there to make your point.

But I'll leave it to Jens to fix up the patch appropriately: for
all I know, there might be arches on which using dma_addr_t there
actually does the wrong thing - I don't think so, but I know too
little about it.

Hugh
