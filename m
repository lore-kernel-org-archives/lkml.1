Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXHVRLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXHVRLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764907AbXHVRLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:11:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35454 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762562AbXHVRK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:10:59 -0400
Message-ID: <46CC6C4B.1030202@sgi.com>
Date: Wed, 22 Aug 2007 19:03:07 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, akepner@sgi.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
References: <20070818002746.GU1813@sgi.com>	 <200708220903.23702.jbarnes@virtuousgeek.org>	 <1187801095.3410.49.camel@localhost.localdomain>	 <200708220951.05101.jbarnes@virtuousgeek.org> <1187802272.3410.58.camel@localhost.localdomain>
In-Reply-To: <1187802272.3410.58.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> I really don't think a work around for a PCI spec violation belongs in
> the generic DMA code, do you?  The correct fix for this should be to set
> the device hints to strict ordering, which presumably altix respects?
> In which case, it sounds like what needs exposing are access to the PCI
> device hints.  I believe both PCI-X and PCIe have these hints as
> optional specifiers in the bridges, so it should be in a current Rev of
> the PCI spec.  Or are you proposing adding an additional PCI API that
> allows transaction flushes to be inserted into the stream for devices
> and bridges that have already negotiated relaxed ordering? ... in which
> case we need to take this to the PCI list.

James,

I don't believe it respects those hints - I agree, it's a pita, but
thats the state of the situation. Even if it did, it would make
performance suck as Jesse also pointed out.

As I pointed out in my email to Willy is that the NUMA fabric is routed,
there's not one path through the system, which is what makes this
happen.

Jes
