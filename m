Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbXKLKwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbXKLKwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbXKLKwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:52:05 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:11744 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485AbXKLKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:52:04 -0500
Date: Mon, 12 Nov 2007 12:52:01 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Amit Shah <amit.shah@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 4/8] KVM: PVDMA: Introduce is_pv_device() dma operation
Message-ID: <20071112105201.GG3299@rhun.haifa.ibm.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com> <218cf425feff1d4daf23d3f25df1eb224108a1a3.1194445109.git.amit.shah@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <218cf425feff1d4daf23d3f25df1eb224108a1a3.1194445109.git.amit.shah@qumranet.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 04:21:05PM +0200, Amit Shah wrote:

> A guest can call dma_ops->is_pv_device() to find out if a device is
> a passthrough'ed device (device passed on to a guest by the
> host). If this is true, a hypercall will be made to translate DMA
> mapping operations.

Doesn't really belong in the DMA mapping API. Instead what I think we
should do is to cache this (per device) value in the pci_device struct
(or device struct?) and in the dma-ops implementation inspect it to
decide exactly how to do DMA mapping for this device.

Cheers,
Muli
