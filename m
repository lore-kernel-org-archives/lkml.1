Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbXKLP6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbXKLP6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXKLP5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:57:53 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:53083 "EHLO
	outbound9-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbXKLP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:57:52 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Mon, 12 Nov 2007 16:55:22 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Amit Shah" <amit.shah@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 1/8] KVM: PVDMA Host: Handle reqeusts
 for guest DMA mappings
Message-ID: <20071112155522.GF6466@amd.com>
References: <1194445269752-git-send-email-amit.shah@qumranet.com>
 <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
MIME-Version: 1.0
In-Reply-To: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 12 Nov 2007 15:55:22.0607 (UTC)
 FILETIME=[6EBEEFF0:01C82544]
X-WSS-ID: 6B26A8E72IW1692266-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 04:21:02PM +0200, Amit Shah wrote:
> @@ -1649,6 +1913,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  	}
>  
>  	switch (nr) {
> +	case KVM_PV_DMA_MAP:
> +		ret = pv_map_hypercall(vcpu, a0, a1);
> +		break;
> +	case KVM_PV_DMA_UNMAP:
> +		ret = pv_unmap_hypercall(vcpu, a0);
> +		break;
> +	case KVM_PV_PCI_DEVICE:
> +		ret = pv_mapped_pci_device_hypercall(vcpu, a0);
> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;

How does synchronization work with that design? I don't see a hypercall
to synchronize de DMA buffers. It will only work if GART is used as the
dma_ops backend on the host side and not with SWIOTLB. But GART can be
configured away.  Or do I miss something?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


