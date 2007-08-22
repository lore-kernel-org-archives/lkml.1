Return-Path: <linux-kernel-owner+w=401wt.eu-S1765018AbXHVSK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765018AbXHVSK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbXHVSKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:10:13 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:34316 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760361AbXHVSKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:10:11 -0400
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jes Sorensen <jes@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, akepner@sgi.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <46CC6C4B.1030202@sgi.com>
References: <20070818002746.GU1813@sgi.com>
	 <200708220903.23702.jbarnes@virtuousgeek.org>
	 <1187801095.3410.49.camel@localhost.localdomain>
	 <200708220951.05101.jbarnes@virtuousgeek.org>
	 <1187802272.3410.58.camel@localhost.localdomain> <46CC6C4B.1030202@sgi.com>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 13:10:05 -0500
Message-Id: <1187806205.3410.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 19:03 +0200, Jes Sorensen wrote:
> James Bottomley wrote:
> > I really don't think a work around for a PCI spec violation belongs in
> > the generic DMA code, do you?  The correct fix for this should be to set
> > the device hints to strict ordering, which presumably altix respects?
> > In which case, it sounds like what needs exposing are access to the PCI
> > device hints.  I believe both PCI-X and PCIe have these hints as
> > optional specifiers in the bridges, so it should be in a current Rev of
> > the PCI spec.  Or are you proposing adding an additional PCI API that
> > allows transaction flushes to be inserted into the stream for devices
> > and bridges that have already negotiated relaxed ordering? ... in which
> > case we need to take this to the PCI list.
> 
> James,
> 
> I don't believe it respects those hints - I agree, it's a pita, but
> thats the state of the situation. Even if it did, it would make
> performance suck as Jesse also pointed out.
> 
> As I pointed out in my email to Willy is that the NUMA fabric is routed,
> there's not one path through the system, which is what makes this
> happen.

Hmm, didn't see the email ... but I'm probably not cc'd on all the
thread.  However ... it isn't that you couldn't do it ... it's that you
don't want to do it because it's faster to violate the spec ... like all
those nice ATA devices that lie about having a cache and then let you
power down with uncommitted data still in it ... they work much faster
for HDIO tests ... and who ever switches their box off?

James


