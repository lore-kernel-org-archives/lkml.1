Return-Path: <linux-kernel-owner+w=401wt.eu-S1765193AbZLQRod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765193AbZLQRod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765146AbZLQRob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:44:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:6494 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759436AbZLQRo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:44:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,414,1257148800"; 
   d="scan'208";a="524107666"
Message-ID: <4B2A6DFA.6000504@intel.com>
Date: Thu, 17 Dec 2009 10:44:26 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: Kumar Gala <galak@kernel.crashing.org>,
       "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
       "B04825@freescale.com" <B04825@freescale.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Vishnu Suresh <Vishnu@freescale.com>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
       Dipen Dudhat <Dipen.Dudhat@freescale.com>,
       Maneesh Gupta <Maneesh.Gupta@freescale.com>,
       "R58472@freescale.com" <R58472@freescale.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com> <20091216164144.daff5468.kim.phillips@freescale.com> <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org> <4B296394.9010709@intel.com> <20091217170958.GE18271@ovro.caltech.edu>
In-Reply-To: <20091217170958.GE18271@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ira W. Snyder wrote:
> Yes, I have used the device_prep_dma_interrupt() functionality quite a
> while back. However, I found it to be pretty much useless.

The specific case it is needed for Talitos/raid is a channel switch 
interrupt.  The interrupt causes the cleanup operation to be run which 
will kick off any pending dependent operations on the xor channel.  In 
the raid case we only have callbacks at the end of a chain, so we need 
the interrupt to kick the engine in an operation chain like 
xor->copy->xor->callback.

--
Dan
