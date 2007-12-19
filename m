Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbXLSVIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbXLSVIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 16:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXLSVIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 16:08:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:53577 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbXLSVID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 16:08:03 -0500
Subject: Re: No dma_sync_* during pci_probe? (Sparc, post 2.6.22 regression)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: stefanr@s5r6.in-berlin.de, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de, krh@bitplanet.net,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <20071217.165032.41424988.davem@davemloft.net>
References: <bug-9160-4803@http.bugzilla.kernel.org/>
	 <47112797.7060003@s5r6.in-berlin.de> <47670BDF.80409@s5r6.in-berlin.de>
	 <20071217.165032.41424988.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 08:07:20 +1100
Message-Id: <1198098440.31714.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-17 at 16:50 -0800, David Miller wrote:

> The problem is likely what device struct you are passing to
> dma_sync_single_for_device(), it has to be a real pci_dev or similar
> that has it's dev_archdata properly initialized.
> 
> I bet dev_archdata in whatever "struct device" is being passed in has
> a NULL iommu pointer or something like that.
> 
> Oh yeah, I see what you're doing, that won't work, please pass in
> the correct device struct pointer.  Please pass in the &pci_dev->dev
> not this ohci->card.device thing.

Yup, this would crash on powerpc 64 bits as well for the same reason.

Ben.


