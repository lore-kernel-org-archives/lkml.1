Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbXI1Wnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbXI1Wnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 18:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbXI1Wnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 18:43:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57663
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752255AbXI1Wnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:43:39 -0400
Date: Fri, 28 Sep 2007 15:43:39 -0700 (PDT)
Message-Id: <20070928.154339.02281405.davem@davemloft.net>
To: akepner@sgi.com
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] allow drivers to flush in-flight DMA v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070928010926.GM30013@sgi.com>
References: <20070928010926.GM30013@sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akepner@sgi.com
Date: Thu, 27 Sep 2007 18:09:26 -0700

> 
> On Altix, DMA may be reordered between a device and host memory. 
> This reordering can happen in the NUMA interconnect, and it usually 
> results in correct operation and improved performance. In some 
> situations it may be necessary to explicitly synchronize DMA from 
> the device.
> 
> This patchset allows a memory region to be mapped with a "dmabarrier". 
> Writes to the memory region will cause in-flight DMA to be flushed, 
> providing a mechanism to order DMA from a device.

My only beef with this patch set is that it seems
a bit much to create a totally new function name every
time we want to set some kind of new attribute on some
DMA object.  Why not add a "dma_set_flags()" or similar
that can be used later on to set other kinds of aspects
we'd like to change?

You can make the arguments "u32 flags" and "int dir".
Actually you should probably use the dma direction
enumaration instead of 'int'.
