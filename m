Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbZFKEPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbZFKEPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 00:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762614AbZFKEP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 00:15:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:59824 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762162AbZFKEPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 00:15:21 -0400
Cc: akpm@linux-foundation.org, davem@davemloft.net,
       mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       Zhang Wei <zw@zh-kernel.org>
Message-Id: <90AED712-28A1-4800-978C-125A887D0DA7@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Li Yang <leoli@freescale.com>
In-Reply-To: <1242117363-14949-1-git-send-email-leoli@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 1/6] rapidio: add common mapping APIs for RapidIO memory access
Date: Wed, 10 Jun 2009 23:13:00 -0500
References: <1242117363-14949-1-git-send-email-leoli@freescale.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 12, 2009, at 3:35 AM, Li Yang wrote:

> Add the mapping functions used to support direct IO memory access of
> rapidIO.
>
> Signed-off-by: Zhang Wei <zw@zh-kernel.org>
> Signed-off-by: Li Yang <leoli@freescale.com>

Use inbnd/outbnd instead of inb/outb which make one think of byte  
level io accessors.

As I look at this I don't think this is the correct API.  I think we  
should be using the DMA mapping API to hide these details.  The  
concept of mapping like this seems to be more a function of FSL's  
Address translation/mapping unit (ATMU) than anything specific to the  
RIO bus standard.

> ---
> drivers/rapidio/rio.c   |   95 ++++++++++++++++++++++++++++++++++++++ 
> +++++++++
> include/linux/rio.h     |   25 ++++++++++++
> include/linux/rio_drv.h |   24 +++++++++---
> 3 files changed, 138 insertions(+), 6 deletions(-)

- k
