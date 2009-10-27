Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZJ0Jrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZJ0Jrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZJ0Jra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:47:30 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:28950 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbZJ0Jra convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:1>);
	Tue, 27 Oct 2009 05:47:30 -0400
Message-Id: <4AE6CFC4020000780001BF75@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 27 Oct 2009 09:47:32 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: <mingo@elte.hu>, <yinghai@kernel.org>, <tglx@linutronix.de>,
       <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent
	 allocations
References: <4AE6C4D3020000780001BF13@vpn.id2.novell.com>
 <20091027181053L.fujita.tomonori@lab.ntt.co.jp>
 <4AE6CA2A020000780001BF51@vpn.id2.novell.com>
 <20091027183658A.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091027183658A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> 27.10.09 10:37 >>>
>On Tue, 27 Oct 2009 09:23:38 +0000
>"Jan Beulich" <JBeulich@novell.com> wrote:
>
>> Because there's quite a few of them - just search for callers of
>> dma_alloc_coherent() passing NULL as the first argument. Of course
>> I'd rather see the fallback gone, but I think this requires cooperation
>> from/action taken by the driver maintainers first. A first step might be
>> to add a WRN_ON() for that case, but I don't see it being reasonable
>> to eliminate the fallback right away. Hence, with it having got broken
>> in .26 I think it is reasonable to fix it for the time being.
>
>Well, the most of them are drivers that nobody cares about (uses).
>
>What drivers did you hit this problem with?

drivers/firmware/dell_rbu.c (on .27.x, and in particular with the derivation
of __GFP_NORETRY from __GFP_DMA, which fortunately doesn't exist in
newer kernels anymore).

>We've lived with the current code for some years so this problem isn't
>urgent at all. Please don't add another workaround for broken code.
>Let's put WARN_ON for callers that use NULL and see who complains.

Jan

