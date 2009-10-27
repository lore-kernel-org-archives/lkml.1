Return-Path: <linux-kernel-owner+w=401wt.eu-S932248AbZJ0JXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbZJ0JXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932219AbZJ0JXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:23:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:26777 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbZJ0JXi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:1>);
	Tue, 27 Oct 2009 05:23:38 -0400
Message-Id: <4AE6CA2A020000780001BF51@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 27 Oct 2009 09:23:38 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: <mingo@elte.hu>, <yinghai@kernel.org>, <tglx@linutronix.de>,
       <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent
	 allocations
References: <4AE5D238020000780001BD46@vpn.id2.novell.com>
 <20091026201917.GE24682@elte.hu>
 <4AE6C4D3020000780001BF13@vpn.id2.novell.com>
 <20091027181053L.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091027181053L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> 27.10.09 10:11 >>>
>If a driver doesn't want to GFP_DMA, it should set up the
>dma_coherent_mask of the device and pass it. In fact, it should do. A
>driver that uses the fallback device is broken.

Agreed.

>Why can't you fix drivers that use the fallback instead of adding
>another hack to the common place?

Because there's quite a few of them - just search for callers of
dma_alloc_coherent() passing NULL as the first argument. Of course
I'd rather see the fallback gone, but I think this requires cooperation
from/action taken by the driver maintainers first. A first step might be
to add a WRN_ON() for that case, but I don't see it being reasonable
to eliminate the fallback right away. Hence, with it having got broken
in .26 I think it is reasonable to fix it for the time being.

Jan

