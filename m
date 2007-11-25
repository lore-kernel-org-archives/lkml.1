Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbXKYBTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbXKYBTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 20:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbXKYBTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 20:19:07 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55082 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbXKYBTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 20:19:06 -0500
Date: Sun, 25 Nov 2007 02:15:51 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alistair John Strachan <alistair@devzero.co.uk>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3, 4GB RAM, swiotlb, r8169, out of space
Message-ID: <20071125011550.GB30759@electric-eye.fr.zoreil.com>
References: <200711242344.49958.alistair@devzero.co.uk> <20071125003910.3e58e3b3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125003910.3e58e3b3@the-village.bc.nu>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> :
[...]
> You seem to have a leak, which actually isn't suprising
> 
> 	rtl8169_xmit_frags allocates a set of maps for a fragmented packet
> 
> 	rtl8169_start_xmit allocates a buffer
> 
> When we finish the transit we free the main buffer (always using skb->len
> when sometimes its skb->headlne. We don't seem to free the fragment
> buffers at all.
> Looks like the unmap path for fragmented packets is broken with any kind
> of iommu

Are you referring to the pci_unmap part ?

There is a 1:1 correspondance between a Tx descriptor entry and
{an unfragmented skb or a fragment of a skb}. Afaiks rtl8169_unmap_tx_skb()
is issued for each Tx descriptor entry, be it after a Tx completion irq or
a general Tx ring cleanup.

I'll read it again after some sleep but the leak does not seem clear to me.

-- 
Ueimor
