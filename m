Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab0BYCXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:23:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:59147 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760Ab0BYCXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:23:41 -0500
Message-ID: <4B85E164.1080104@kernel.org>
Date: Thu, 25 Feb 2010 11:33:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 16/35] x86: make 64 bit use early_res instead of bootmem
 before slab
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	 <1265793639-15071-17-git-send-email-yinghai@kernel.org>	 <20100215010833.15f9e09a.sfr@canb.auug.org.au>	 <4B7B4378.1070206@kernel.org> <1267052387.12790.10.camel@laptop> <4B85B65E.503@kernel.org> <4B85B724.9050304@kernel.org> <4B85DB79.4010708@kernel.org> <4B85DCAF.5030304@kernel.org>
In-Reply-To: <4B85DCAF.5030304@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 02:23:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/25/2010 11:13 AM, Yinghai Lu wrote:
> ok, will add free_early_partial to handle it.

Great.

> i got impression, when we are moving slab ealier.  you said that
> will check to make percpu setup to use slab allocator instead.

I don't recall exactly but it probably was 4k remapping everything
into vmalloc area and didn't need large contiguous area.  The problem
with the former approach was that it added a lot of extra TLB
pressure.  The current allocator avoids that by overlaying the static
percpu areas onto the linear address space which requires punching
holes in an contiguous area.

Thanks.

-- 
tejun
