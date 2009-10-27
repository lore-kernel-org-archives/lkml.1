Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZJ0JiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZJ0JiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZJ0JiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:38:15 -0400
Received: from sh.osrg.net ([192.16.179.4]:43560 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZJ0JiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 05:38:14 -0400
Date: Tue, 27 Oct 2009 18:37:15 +0900
To: JBeulich@novell.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, yinghai@kernel.org,
       tglx@linutronix.de, tiwai@suse.de, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, hpa@zytor.com
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent	 allocations
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4AE6CA2A020000780001BF51@vpn.id2.novell.com>
References: <4AE6C4D3020000780001BF13@vpn.id2.novell.com>
	<20091027181053L.fujita.tomonori@lab.ntt.co.jp>
	<4AE6CA2A020000780001BF51@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091027183658A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Oct 2009 18:37:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 09:23:38 +0000
"Jan Beulich" <JBeulich@novell.com> wrote:

> Because there's quite a few of them - just search for callers of
> dma_alloc_coherent() passing NULL as the first argument. Of course
> I'd rather see the fallback gone, but I think this requires cooperation
> from/action taken by the driver maintainers first. A first step might be
> to add a WRN_ON() for that case, but I don't see it being reasonable
> to eliminate the fallback right away. Hence, with it having got broken
> in .26 I think it is reasonable to fix it for the time being.

Well, the most of them are drivers that nobody cares about (uses).

What drivers did you hit this problem with?

We've lived with the current code for some years so this problem isn't
urgent at all. Please don't add another workaround for broken code.
Let's put WARN_ON for callers that use NULL and see who complains.
