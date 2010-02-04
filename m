Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab0BDFQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 00:16:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49013 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab0BDFQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 00:16:06 -0500
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
       Catalin Marinas <catalin.marinas@arm.com>
CC: Daniel Walker <dwalker@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
       "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Larry Bassel <lbassel@quicinc.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 4 Feb 2010 10:45:29 +0530
Subject: RE: [RFC PATCH] ARM: Change the mandatory barriers implementation
Thread-Topic: [RFC PATCH] ARM: Change the mandatory barriers implementation
Thread-Index: AcqlMEA4RYb5hBdcQayfD2BC9g1QewAJ/JXA
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C0B421AC@dbde02.ent.ti.com>
References: <20100203161434.15912.42697.stgit@pc1117.cambridge.arm.com>
 <4B6A131B.1070005@codeaurora.org>
In-Reply-To: <4B6A131B.1070005@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-
> bounces@lists.infradead.org] On Behalf Of Abhijeet Dharmapurikar
> Sent: Thursday, February 04, 2010 5:52 AM
> To: Catalin Marinas
> Cc: Daniel Walker; Russell King; Tony Lindgren; linux-arm-msm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Larry Bassel; linux-arm-kernel@lists.infradead.org
> Subject: Re: [RFC PATCH] ARM: Change the mandatory barriers implementation
> 
> > The mandatory barriers (mb, rmb, wmb) are used even on uniprocessor
> > systems for things like ordering Normal Non-cacheable memory accesses
> > with DMA transfer (via Device memory writes). The current implementation
> > uses dmb() for mb() and friends but this is not sufficient. The DMB only
> > ensures the ordering of accesses with regards to a single observer
> > accessing the same memory. If a DMA transfer is started by a write to
> > Device memory, the data to be transfered may not reach the main memory
> > (even if mapped as Normal Non-cacheable) before the device receives the
> > notification to begin the transfer. The only barrier that would help in
> > this situation is DSB which would completely drain the write buffers.
> 
> On ARMv7, DMB guarantees that all accesses prior to DMB are observed by
> an observer if that observer sees any accesses _after_ the DMB. In this
> case, since DMA engine observes a write to itself( It is being written
> to and hence must observe the write) it should also see the writes to
> the buffers. A dmb() after the writes to buffer and before write to DMA
> engine should suffice.
This may be true if the DMA engine is an observer in the cluster. Without
coherence hardware, DMA won't see the correct data without draining the write
buffer. So DSB is necessary in DMA case at least.

Regards,
Santosh
