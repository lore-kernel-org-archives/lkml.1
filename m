Return-Path: <linux-kernel-owner+w=401wt.eu-S934972AbYETWfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934972AbYETWfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbYETWfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:35:08 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:44060 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934775AbYETWfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:35:07 -0400
Message-ID: <4833524C.3040207@freescale.com>
Date: Tue, 20 May 2008 17:35:56 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: benh@kernel.crashing.org, Trent Piepho <tpiepho@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>	<1211318219.8297.177.camel@pasglop>	<483344C0.3020703@freescale.com> <20080520231516.76b924a2@core>
In-Reply-To: <20080520231516.76b924a2@core>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> It looks like we rely on -fno-strict-aliasing to prevent reordering 
>> ordinary memory accesses (such as to DMA descriptors) past the I/O 
> 
> DMA descriptors in main memory are dependant on cache behaviour anyway
> and the dma_* operators should be the ones enforcing the needed behaviour.

What about memory obtained from dma_alloc_coherent()?  We still need a 
sync and a compiler barrier.  The current I/O accessors have the former, 
but not the latter.

-Scott
