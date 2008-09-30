Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYI3T5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYI3T5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYI3T5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:57:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbYI3T5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:57:23 -0400
Message-ID: <48E2846A.4030802@linux-foundation.org>
Date: Tue, 30 Sep 2008 14:56:26 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: wrong usage of MAX_DMA_ADDRESS in bootmem.h
References: <1222230419-15661-21-git-send-email-nico@cam.org> <1222230592-15868-1-git-send-email-nico@cam.org> <20080930162809.GD15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301409230.3635@xanadu.home> <20080930184411.GJ15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301513260.3635@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.0809301513260.3635@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> I have implemented highmem for ARM.  To catch wrong usage of __pa() and 
>
> One issue is that bootmem.h uses __pa(MAX_DMA_ADDRESS). However 
> MAX_DMA_ADDRESS on ARM is defined as 0xffffffff because there is usually 
> no restriction on the maximum DMA-able address.
> 
> RMK suggested that those places should be using ISA_DMA_THRESHOLD 
> instead -- here's an excert of our conversation on this topic:
>

ok so do

#define MAX_DMA_ADDRESS ISA_DMA_THRESHOLD

 >> I suspect all those places which are doing __pa(MAX_DMA_ADDRESS) really
>> want to be using ISA_DMA_THRESHOLD - that's something to raise on LKML
>> if it's causing problems.

MAX_DMA_ADDRESS is the highest address used for ZONE_DMA / GFP_DMA

Does ISA_DMA_THRESHOLD have any meaning on ARM? If you use old ISA stuff then
you need CONFIG_ZONE_DMA and therefore also MAX_DMA_ADDRESS.

If not then there is no need to define CONFIG_ZONE_DMA and MAX_DMA_ADDRESS
looses its usual meaning.
