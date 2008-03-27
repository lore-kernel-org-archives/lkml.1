Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYC0FNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYC0FNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 01:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYC0FN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 01:13:28 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:2249 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYC0FN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 01:13:27 -0400
Date: Wed, 26 Mar 2008 23:15:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: memory-barriers.txt: cache coherency vs mmio
In-reply-to: <fa.I0PBRKboi+ZcSNf2wJaKd5/Lavw@ifi.uio.no>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <47EB2D67.9090609@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.I0PBRKboi+ZcSNf2wJaKd5/Lavw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> The subject section in memory-barriers.txt says:
> 
> "[...] MMIO accesses may, in effect, overtake accesses to cached memory 
> that were emitted earlier. A memory barrier isn't sufficient in such a 
> case, but rather the cache must be flushed between the cached memory 
> write and the MMIO access if the two are in any way dependent."
> 
> And the lowly driver programmer immediately asks:
> How do I flush the cache?
> 
> In particular, do I have to do anyhing between
> 
>     coherent_dma_buffer->datum = something;
> 
>     writel(YOU_CAN_START_DMA_NOW, register);
> 
> Thanks,

That part of the document seems kind of bogus to me. Or rather, if it's 
true and there are architectures where ordering between normal memory 
writes and MMIO is not ensured even with wmb(), that's the bogus part. 
Driver authors should not have to deal with that sort of thing.

