Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbYBLI7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbYBLI7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbYBLI7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:59:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46774
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbYBLI7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:59:34 -0500
Date: Tue, 12 Feb 2008 01:00:06 -0800 (PST)
Message-Id: <20080212.010006.255202479.davem@davemloft.net>
To: muli@il.ibm.com
Cc: mgross@linux.intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH]intel-iommu batched iotlb flushes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080212085256.GF5750@rhun.haifa.ibm.com>
References: <20080211224105.GB24412@linux.intel.com>
	<20080212085256.GF5750@rhun.haifa.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>
Date: Tue, 12 Feb 2008 10:52:56 +0200

> The streaming DMA-API was designed to conserve IOMMU mappings for
> machines where IOMMU mappings are a scarce resource, and is a poor
> fit for a modern IOMMU such as VT-d with a 64-bit IO address space
> (or even an IOMMU with a 32-bit address space such as Calgary) where
> there are plenty of IOMMU mappings available.

For the 64-bit case what you are suggesting eventually amounts
to mapping all available RAM in the IOMMU.

Although an extreme version of your suggestion, it would be the
most efficient as it would require zero IOMMU flush operations.

But we'd lose things like protection and other benefits.
