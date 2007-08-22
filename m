Return-Path: <linux-kernel-owner+w=401wt.eu-S1765643AbXHVRRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765643AbXHVRRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763163AbXHVRR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:17:26 -0400
Received: from outbound-mail-44.bluehost.com ([69.89.18.13]:42533 "HELO
	outbound-mail-44.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759842AbXHVRRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:17:25 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
Date: Wed, 22 Aug 2007 10:17:11 -0700
User-Agent: KMail/1.9.7
Cc: Jes Sorensen <jes@sgi.com>, akepner@sgi.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
References: <20070818002746.GU1813@sgi.com> <200708220951.05101.jbarnes@virtuousgeek.org> <1187802272.3410.58.camel@localhost.localdomain>
In-Reply-To: <1187802272.3410.58.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221017.11805.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 22, 2007 10:04:32 am James Bottomley wrote:
> The spec isn't ambiguous ... it says if the device and bridge agree on
> relaxed ordering, then it *may* be observed in the transaction.  If
> there's a disagreement or neither wishes to support relaxed ordering
> then the transaction *must* be strict.

Arg, don't make me dig out my spec, I don't have it handy...

> I really don't think a work around for a PCI spec violation belongs in
> the generic DMA code, do you?  The correct fix for this should be to set
> the device hints to strict ordering, which presumably altix respects?

Well, the Altix hw by itself won't honor device hints (I'm not even sure if 
there are devices that honor order hints like you outline above).  However, 
Altix could track per-device ordering as long as arch code was called from 
such a hook.

> In which case, it sounds like what needs exposing are access to the PCI
> device hints.  I believe both PCI-X and PCIe have these hints as
> optional specifiers in the bridges, so it should be in a current Rev of
> the PCI spec.  Or are you proposing adding an additional PCI API that
> allows transaction flushes to be inserted into the stream for devices
> and bridges that have already negotiated relaxed ordering? ... in which
> case we need to take this to the PCI list.

I think it would have to be the latter, since otherwise it would be hard to 
setup just completion queue requests to be ordered.

Jesse


