Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXGOJwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXGOJwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXGOJwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:52:40 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:22773 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367AbXGOJwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:52:39 -0400
X-IronPort-AV: i="4.16,540,1175486400"; 
   d="scan'208"; a="34916341:sNHT25052671"
Subject: Re: [PATCH 1/3] Blackfin ethernet driver: on chip ethernet MAC
	controller driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Michael Buesch <mb@bu3sch.de>
Cc: bryan.wu@analog.com, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200707151136.05223.mb@bu3sch.de>
References: <1184438993.3140.23.camel@roc-laptop>
	 <200707142138.36619.mb@bu3sch.de> <1184491016.3140.52.camel@roc-laptop>
	 <200707151136.05223.mb@bu3sch.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Sun, 15 Jul 2007 17:52:30 +0800
Message-Id: <1184493150.3140.65.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 15 Jul 2007 09:52:36.0582 (UTC) FILETIME=[DF9D1860:01C7C6C5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 11:36 +0200, Michael Buesch wrote:
> On Sunday 15 July 2007 11:16:56 Bryan Wu wrote:
> > In current Blackfin DMA allocation/free, the return value from 
> > bfin_mac_alloc() is used as the dma_handle, here it is the
> > tx_desc/rx_desc. 
> > The "dma_handle" is useless in the following code.
> 
> I think a comment has to be added, at least, as it's very confusing.

No problem, it should be.
> 
> > This is some magic code for PHY ID. In the future, we will rewrite some
> > code based on kernel phy abstraction layer to support more phy device.
> 
> Ok, nice idea.
> 
> > > Unwind the allocations above, if registering fails.
> > > 
> > 
> > In fact, it is safe. Because if registering fails, bf537mac_probe will
> > return none zero to bfin_mac_probe which will do free_netdev.
> 
> Hm, weren't there some DMA allocations, too? Are they free'd properly?
> 

Oh, the DMA allocation happens in bf537mac_open not in bf537mac_probe.
so when registering fails, only free_netdev should be ok.

I sent out a new driver patch for #2 try, please give us some comments

Thanks
- Bryan Wu
