Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbXKLROn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbXKLROn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXKLROf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:14:35 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:44634 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbXKLROe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:14:34 -0500
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Technologies
To: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Re: [kvm-devel] [PATCH 1/8] KVM: PVDMA Host: Handle reqeusts for guest DMA mappings
Date: Mon, 12 Nov 2007 22:37:29 +0530
User-Agent: KMail/1.9.6
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1194445269752-git-send-email-amit.shah@qumranet.com> <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com> <20071112155522.GF6466@amd.com>
In-Reply-To: <20071112155522.GF6466@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711122237.29369.amit.shah@qumranet.com>
X-OriginalArrivalTime: 12 Nov 2007 17:14:33.0557 (UTC) FILETIME=[7E886050:01C8254F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007 21:25:22 Joerg Roedel wrote:
> On Wed, Nov 07, 2007 at 04:21:02PM +0200, Amit Shah wrote:
> > @@ -1649,6 +1913,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  	}
> >
> >  	switch (nr) {
> > +	case KVM_PV_DMA_MAP:
> > +		ret = pv_map_hypercall(vcpu, a0, a1);
> > +		break;
> > +	case KVM_PV_DMA_UNMAP:
> > +		ret = pv_unmap_hypercall(vcpu, a0);
> > +		break;
> > +	case KVM_PV_PCI_DEVICE:
> > +		ret = pv_mapped_pci_device_hypercall(vcpu, a0);
> > +		break;
> >  	default:
> >  		ret = -KVM_ENOSYS;
> >  		break;
>
> How does synchronization work with that design? I don't see a hypercall
> to synchronize de DMA buffers. It will only work if GART is used as the
> dma_ops backend on the host side and not with SWIOTLB. But GART can be
> configured away.  Or do I miss something?

A per-VM lock is needed while mapping or unmapping. It's one of the TODOs.
