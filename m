Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbXIQQN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbXIQQN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbXIQQNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:13:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:58696 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbXIQQNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,265,1186383600"; 
   d="scan'208";a="280793715"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Remove an unused variable from the Intel I/OAT DMA engine driver
Date: Mon, 17 Sep 2007 09:13:05 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C030BB505@orsmsx418.amr.corp.intel.com>
In-Reply-To: <200709162331.50784.jesper.juhl@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Remove an unused variable from the Intel I/OAT DMA engine driver
thread-index: Acf4qXznhpdYB6qqRo67Ah8c6eriXwAnAxHw
References: <200709162331.50784.jesper.juhl@gmail.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Sep 2007 16:13:17.0943 (UTC) FILETIME=[A8903070:01C7F945]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Jesper Juhl [mailto:jesper.juhl@gmail.com] 
>Sent: Sunday, September 16, 2007 2:32 PM
>To: linux-kernel@vger.kernel.org
>Cc: Nelson, Shannon; Leech, Christopher; Jesper Juhl
>Subject: [PATCH] Remove an unused variable from the Intel 
>I/OAT DMA engine driver
>
>
>The 'u16 chanctrl' variable in 
>drivers/dma/ioatdma.c::ioat_dma_free_chan_resources() is completely 
>unused and gcc quite rightfully warns about it:
>
>  drivers/dma/ioatdma.c:247: warning: unused variable 'chanctrl'
>
>This patch removes the unused variable and silences the warning.
>
>
>Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>---
>
> ioatdma.c |    1 -
> 1 file changed, 1 deletion(-)
>
>--- linux-2.6/drivers/dma/ioatdma.c~	2007-09-16 
>23:24:20.000000000 +0200
>+++ linux-2.6/drivers/dma/ioatdma.c	2007-09-16 
>23:24:20.000000000 +0200
>@@ -244,7 +244,6 @@ static void ioat_dma_free_chan_resources
> 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
> 	struct ioat_device *ioat_device = to_ioat_device(chan->device);
> 	struct ioat_desc_sw *desc, *_desc;
>-	u16 chanctrl;
> 	int in_use_descs = 0;
> 
> 	ioat_dma_memcpy_cleanup(ioat_chan);
>

Yep, thanks.  That's actually used in an internal version of the driver
and got missed in the stipping.  I'll be sure it is properly taken care
of in the future.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
