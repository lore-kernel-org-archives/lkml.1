Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbXKLQAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbXKLQAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXKLQAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:00:44 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:64824 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbXKLQAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:00:42 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Mon, 12 Nov 2007 17:00:23 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
cc: "Amit Shah" <amit.shah@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] KVM: PVDMA Guest: Guest-side
 routines for paravirtualized DMA
Message-ID: <20071112160023.GG6466@amd.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
 <609d5d611a5fb58ab5a7184be7b6d29494023ba0.1194445109.git.amit.shah@qumranet.com>
 <20071112105001.GF3299@rhun.haifa.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20071112105001.GF3299@rhun.haifa.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 12 Nov 2007 16:00:23.0593 (UTC)
 FILETIME=[2225C190:01C82545]
X-WSS-ID: 6B26A7170QK1672314-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 12:50:01PM +0200, Muli Ben-Yehuda wrote:
> On Wed, Nov 07, 2007 at 04:21:04PM +0200, Amit Shah wrote:
> 
> > We make the dma_mapping_ops structure to point to our structure so
> > that every DMA access goes through us. (This is the reason this only
> > works for 64-bit guest. 32-bit guest doesn't yet have a dma_ops
> > struct.)
> 
> I need the same facility for Calgary for falling back to swiotlb if a
> translation is disabled on some slot, and IB needs the same facility
> for some IB adapters (e.g., ipath). Perhaps it's time to consider
> stackable dma-ops (unless someone has a better idea...).

Stackable dma-ops sounds good to me. The only problem is that there is a
performance penalty for devices handled on the bottom of the stack. But
the alternative I can think of, a per-device dma-ops structure, uses more
memory and is much more intrusive to the driver core. So I am fine with
a stackable solution.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


