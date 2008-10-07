Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYJGJJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYJGJJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYJGJJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:09:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:30143 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbYJGJJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,371,1220252400"; 
   d="scan'208";a="56129802"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: dmaengine: DMA_CTRL_ACK flag signification
Date: Tue, 7 Oct 2008 10:09:31 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C102121A73@swsmsx413.ger.corp.intel.com>
In-Reply-To: <48DA2B94.3020804@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: dmaengine: DMA_CTRL_ACK flag signification
Thread-Index: AckePQS/9x3ZGzOSRvW2pU5zSPgSPgKFTI9Q
References: <48DA2B94.3020804@atmel.com>
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
X-OriginalArrivalTime: 07 Oct 2008 09:09:33.0135 (UTC) FILETIME=[69A5DDF0:01C9285C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> Hi all,
> 
> I am in the process of writing a driver for an on-chip Atmel DMA
> engine. 
> 
> I am a little confused about the use of the flag DMA_CTRL_ACK : It
> seems that it is set in most of the descriptors in use except the
> first or last of a descriptor chain. So, I cannot find where this
> flag is cleared. In short, I do not see what it is used for : how
> must I take it into account in my driver (in device_prep_dma_memcpy()
> for instance) ? 
> 
> Can you enlighten me ?
> 
> Regards,

Hi Nicolas,

Sorry for the delay in response.
Generally the idea behind DMA_CTRL_ACK is to let an application 
safely set a chain of dependent operations.
What a DMA driver needs to do is to check 
if a given descriptor has been already acked (using async_tx_test_ack())
before it recycles or releases it.
You are right that there is no place where DMA_CTRL_ACK 
is cleared at the moment. I would say it is the offload engine driver 
responsibility to clear the flag when it recycles the descriptor.
Dan, could you confirm?

Regards,
Maciej
