Return-Path: <linux-kernel-owner+w=401wt.eu-S936627AbZLQSpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936627AbZLQSpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936558AbZLQSpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:45:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:36028 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936484AbZLQSpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:45:21 -0500
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <4B2A6DFA.6000504@intel.com>
Date: Thu, 17 Dec 2009 12:45:01 -0600
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
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
Content-Transfer-Encoding: 8BIT
Message-Id: <AFE3AE33-41FB-42EE-A861-9C6CC1D1F435@kernel.crashing.org>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com> <20091216164144.daff5468.kim.phillips@freescale.com> <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org> <4B296394.9010709@intel.com> <20091217170958.GE18271@ovro.caltech.edu> <4B2A6DFA.6000504@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 17, 2009, at 11:44 AM, Dan Williams wrote:

> Ira W. Snyder wrote:
>> Yes, I have used the device_prep_dma_interrupt() functionality quite a
>> while back. However, I found it to be pretty much useless.
> 
> The specific case it is needed for Talitos/raid is a channel switch interrupt.  The interrupt causes the cleanup operation to be run which will kick off any pending dependent operations on the xor channel.  In the raid case we only have callbacks at the end of a chain, so we need the interrupt to kick the engine in an operation chain like xor->copy->xor->callback.

Ok, I'm still confused as to how the DMA interrupt interacts with the Talitos/raid side of things.  The should be completely independent (separate interrupts, separate IP blocks).

- k