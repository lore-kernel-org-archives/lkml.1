Return-Path: <linux-kernel-owner+w=401wt.eu-S1765100AbZLQRa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765100AbZLQRa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765038AbZLQRaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:30:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:48573 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764977AbZLQRaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:30:18 -0500
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091217170958.GE18271@ovro.caltech.edu>
Date: Thu, 17 Dec 2009 11:29:26 -0600
Cc: Dan Williams <dan.j.williams@intel.com>,
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
Message-Id: <C0E3E9A1-7B65-4D57-8813-C2F4B4E2060B@kernel.crashing.org>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com> <20091216164144.daff5468.kim.phillips@freescale.com> <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org> <4B296394.9010709@intel.com> <20091217170958.GE18271@ovro.caltech.edu>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 17, 2009, at 11:09 AM, Ira W. Snyder wrote:

> On Wed, Dec 16, 2009 at 03:47:48PM -0700, Dan Williams wrote:
>> Kumar Gala wrote:
>>>>> Changes with respect to v1 as per comments received
>>>>> o. Rebased to linux-next as of 20091216
>>>>> o. The selection is based exclusive of fsldma
>>>>> o. Intoduced a new Kernel Configuration variable
>>>>>  *. This enables selecting the Cryptographic functionality
>>>>>     of Talitos along with fsldma.
>>>>>  *. Disables the XOR parity calculation offload, if fsldma enabled
>>>>>     either as kernel in-built or as a module
>>>>>  *. Once the inter-operability with fsldma is resolved, this option
>>>>>     can be removed
>>>> wait, why can't the interoperability bug be fixed in the first place?
>>> 
>>> I agree w/Kim.  We need to better understand what the bug is and how to reproduce it so we can get to the root cause.
>>> 
>>> Paper taping over it by disabling fsldma is not the right solution.
>> 
>> Hopefully this prompts fsldma authors to get involved because the 
>> interoperability issue has been out there without comment*, just 
>> band-aids, since October.
>> 
>> --
>> Dan
>> 
>> * well one comment from Ira saying the interrupt functionality worked 
>> for him.
> 
> Yes, I have used the device_prep_dma_interrupt() functionality quite a
> while back. However, I found it to be pretty much useless. Any
> functionality I need is covered by adding a callback to the last DMA
> memcpy() operation. Since the operations happen in-order, I can be sure
> that the entire set of memcpy()s cas completed. I never needed the
> capability to generate an interrupt without a memcpy().
> 
> I agree that the fsldma driver could use some love. There are places
> where I am still not confident in the locking. Perhaps I can find some
> time over Christmas to work on it, but I need someone with 85xx/86xx
> hardware to test the changes. I only have 83xx hardware.

I can test on 85xx/86xx if you work up some patches.

- k