Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbXKWBRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbXKWBRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXKWBRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:17:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:62593 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXKWBRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LIcyNRWH9bjBfiZAHDWJ97rAtyL2N8s/aEQL5ukJ1frPAsaDz8mVmU5JXCx2vsyZrJOugw/8UGpL8Um9AzoaMzIksoXjaezoe8siZgq6Mtgi8DhAI2c5/piUGIrGqlak6+6MjX1DH/Czh1cts6khOvsK12kK1dQvCH7A33nGgyc=
Message-ID: <47462A25.1060207@gmail.com>
Date: Fri, 23 Nov 2007 10:17:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v2)
References: <47438248.7030704@shaw.ca> <4745234E.9050409@gmail.com> <47462673.3080701@shaw.ca>
In-Reply-To: <47462673.3080701@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>>> +    /* Ensure DMA mask is set to 32-bit before allocating legacy PRD
>>> and
>>> +       pad buffers */
>>> +    pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
>>> +    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
>> [--snip--]
>>> +    pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
>>> +    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
>>
>> I'm probably being paranoid here but please add error checks.  Just
>> checking return value and returning error suffices.
> 
> In the 32-bit case, I'm pretty sure those are guaranteed not to fail
> because 32-bit is the default. For the 64-bit ones, we don't care if
> they fail, because then we'll just use whatever mask ends up being set
> (we store the actual set DMA mask in adma_dma_mask for use when we need
> to reconfigure the bounce limit). We definitely don't want to fail
> initialization if the 64-bit set doesn't succeed..

Then please add BUG or WARN_ON after 32bit switching (but then again if
you're gonna do that why not just add if (rc) return rc?) and add
comment stating setting 64 bit dma masks is allowed to fail.

Thanks.

-- 
tejun
