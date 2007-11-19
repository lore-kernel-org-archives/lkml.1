Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbXKSIiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbXKSIiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbXKSIiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:38:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52024
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbXKSIiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:38:02 -0500
Date: Mon, 19 Nov 2007 00:38:02 -0800 (PST)
Message-Id: <20071119.003802.100741794.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: SCSI breakage on non-cache coherent architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <1195450523.7022.37.camel@pasglop>
References: <1195450523.7022.37.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 19 Nov 2007 16:35:23 +1100

> I'm not sure what is the best way to fix that. Internally, I've done
> some test whacking some ____cacheline_aligned in the scsi_cmnd data
> structure to verify I no longer get random SLAB corruption when using my
> USB but that significantly bloats the size of the structure on archs
> such as ppc64 that don't need it and have a large cache line size.
> 
> Unfortunately, I don't think there's any existing Kconfig symbol or arch
> provided #define to tell us that we are on a non-coherent arch afaik
> that could be used to make that conditional.
> 
> Another option would be to kmalloc the buffer (wasn't it the case before
> btw ?) but I suppose some people will scream at the idea due to how the
> command pools are done...

You could make a ____dma_cacheline_aligned and use that.
It seems pretty reasonable.
