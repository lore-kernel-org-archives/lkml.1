Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZLRPCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZLRPCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZLRPCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:02:45 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:62428 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbZLRPCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:02:43 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Date: Fri, 18 Dec 2009 23:02:22 +0800
Message-ID: <3A45394FD742FA419B760BB8D398F9ED01059526@zch01exm26.fsl.freescale.net>
In-Reply-To: <4B2A6DFA.6000504@intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Thread-Index: Acp/QJjbCvSWhk0cRXm3DFSA88fqVgAsgd9A
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com> <20091216164144.daff5468.kim.phillips@freescale.com> <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org> <4B296394.9010709@intel.com> <20091217170958.GE18271@ovro.caltech.edu> <4B2A6DFA.6000504@intel.com>
From: "Li Yang-R58472" <r58472@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: "Kumar Gala" <galak@kernel.crashing.org>, <herbert@gondor.apana.org.au>,
       "Tabi Timur-B04825" <B04825@freescale.com>,
       <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>,
       "Suresh Vishnu-B05022" <B05022@freescale.com>,
       <linux-crypto@vger.kernel.org>,
       "Dudhat Dipen-B09055" <B09055@freescale.com>,
       "Gupta Maneesh-B18878" <B18878@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for 
>Async_tx XOR offload
>
>Ira W. Snyder wrote:
>> Yes, I have used the device_prep_dma_interrupt() 
>functionality quite a 
>> while back. However, I found it to be pretty much useless.
>
>The specific case it is needed for Talitos/raid is a channel 
>switch interrupt.  The interrupt causes the cleanup operation 
>to be run which will kick off any pending dependent operations 
>on the xor channel.  In the raid case we only have callbacks 
>at the end of a chain, so we need the interrupt to kick the 
>engine in an operation chain like 
>xor->copy->xor->callback.

I am wondering if can use more callbacks to kick off pending dependent operations?
Like xor->callback->copy->callback->xor->callback?

- Leo
