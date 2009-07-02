Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZGBBoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZGBBoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZGBBoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:44:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41924 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbZGBBoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:44:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Jul 2009 10:42:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daniel Kabs <daniel.kabs@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: adjusting lowmem_reserve_ratio on an embedded system?
Message-Id: <20090702104227.1c07e85f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200907011423.52798.daniel.kabs@gmx.de>
References: <200907011423.52798.daniel.kabs@gmx.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 14:23:52 +0200
Daniel Kabs <daniel.kabs@gmx.de> wrote:

> Hello,
> 
> in tracing a low on memory situation on an embedded system I came across 
> the Documentation/sysctl/vm.txt. There it is advised to change the 
> lowmem_reserve_ratio on systems running without swap.
> 
> I wonder if this applies for an embedded system running with 256MByte RAM 
> and no swap which is using only one memory zone (ZONE_NORMAL)? I guess 
> no.
> 
> 
> To understand what the parameter means I read the relevant section from 
> vm.txt and came across the terms "lowmem zone" and "lower zones" 
> and "lowmem memory". I feel dumb. I could not find a concept of "lower 
> zones" (or "upper" zones).  What exactly do they mean?
> 
Assume a system with HIGHMEM/NORMAL/DMA

zone fallback list is created as

	HIGHMEM->NORMAL->DMA

HIGHMEM's lower zone is NORMAL+DMA
NORMAL's lower zone is DMA.

"lowmem" often means NORMAL+DMA (yes, there are HIGHMEM) but it depends on context.

Regards,
-Kame

