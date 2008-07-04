Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYGDBYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYGDBYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758415AbYGDBXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:23:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:43200 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405AbYGDBXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:23:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,300,1212390000"; 
   d="scan'208";a="584961536"
Subject: Re: Extending Linux async_tx interface
From: Dan Williams <dan.j.williams@intel.com>
To: Subrahmanyam Bolla <sbolla@amcc.com>
Cc: linux-kernel@vger.kernel.org,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Tushar Tyagi <ttyagi@amcc.com>, Loc Ho <lho@amcc.com>
In-Reply-To: <9D1E2BDCB5C57B46B56E6D80843439EB055445D7@SDCEXCHANGE01.ad.amcc.com>
References: <9D1E2BDCB5C57B46B56E6D80843439EB055445D7@SDCEXCHANGE01.ad.amcc.com>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 18:23:13 -0700
Message-Id: <1215134593.25483.9.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-06-23 at 16:07 -0700, Subrahmanyam Bolla wrote:
> Hi,
> 
> I'm working on a new DMA driver for our hardware that supports various
> modes of operations like memory to memory, memory to custom format, and
> visa-versa.
> The current Linux async_tx DMA interface only supports memory to memory
> transfer. We would like to extend this interface to support our
> hardware's new capabilities.
> 
> Other than async_memcpy and async_memset operations supported by linux
> async_tx interface, we would like to add something like
> async_mem_buff_cpy,
> async_pkt_mem_cpy and a few more. These new operations use a new format
> for specifying the source and/or destination for doing the transfer.
> To support this we will have new structures as the API parameters.
> 
> Could you pls let me know if this is the right approach or if there are
> any other suggestions.
> 
It is difficult to know if this is the right approach without knowing
more about the intended usage.  For example async_tx is meant for code
paths where it does not matter if an offload engine is available.
Compare that to Haavard's dma-slave implementation where the driver is
explicitly using a specific dma channel[1].  Which approach better fits
what you are trying to accomplish?

--
Dan

[1] http://marc.info/?l=linux-kernel&m=121448921821512&w=2



