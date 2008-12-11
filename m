Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYLKBAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYLKBAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYLKBAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:00:07 -0500
Received: from main.gmane.org ([80.91.229.2]:45824 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYLKBAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:00:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] USB: use stack allocation for struct usb_ctrlrequest
Date: Wed, 10 Dec 2008 18:59:34 -0600
Message-ID: <494065F6.3010602@shaw.ca>
References: <20081210073247.GA18630@localhost> <200812101040.09886.laurent.pinchart@skynet.be> <20081210124308.GB6772@localhost> <493FCD12.30000@codefidence.com> <20081210142301.GA11490@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-usb@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <20081210142301.GA11490@localhost>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
>> In many cases there is no problem to DMA high memory. If you happen to 
>> be working with a device that does have problems with full 32 bit 
>> addresses then GFP_DMA would be the right flag, not GFP_NOIO.
> 
> For 64bit systems, we can easily go beyond 4GB physical memory.
> So at least we should add GFP_DMA32 in addition to GFP_NOIO?

No. The DMA mapping API handles either setting up the IOMMU or doing 
software bounce buffering to handle the DMA transfer regardless of where 
the memory is located, so drivers don't need to mess with GFP_DMA32.

