Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050Ab0ARMV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0ARMV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953Ab0ARMV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:21:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab0ARMVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:21:55 -0500
Message-ID: <4B545262.4020907@suse.cz>
Date: Mon, 18 Jan 2010 13:21:54 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve kconfig symbol hashing
References: <20100113160244.GA14012@basil.fritz.box>
In-Reply-To: <20100113160244.GA14012@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.1.2010 17:02, Andi Kleen wrote:
[...]
> This patch increases the hash table size to a larger prime
> and switches to a FNV32 hash. I played around with a couple of hash
> functions, but that one seemed to perform best with reasonable
> hash table sizes. 
> 
> Increasing the hash table size even further didn't
> seem like a good idea, because there are a couple of global
> walks which walk the complete hash table.
> 
> I also moved the unnamed bucket to 0. It's still the longest
> of all the buckets (44 entries), but hopefully it's not
> often hit except for the global walk which doesn't care.
> 
> The result is a much nicer distribution:
> (first column bucket length, second number of buckets with that length)
> 
> 1: 3505
> 2: 1236
> 3: 294
> 4: 52
> 5: 3
> 47: 1		<--- this is the unnamed symbols bucket
> 
> There are still some 5+ buckets, but increasing the hash table
> even more would be likely not worth it.
> 
> This also cleans up the code slightly by removing hard coded
> magic numbers.
> 
> I didn't notice a big performance difference either way 
> on my Nehalem system, but I presume it'll help somewhat
> on slower systems.
> 
> ---
>  scripts/kconfig/expr.h              |    5 ++---
>  scripts/kconfig/symbol.c            |   29 +++++++++++++++++------------
>  scripts/kconfig/zconf.tab.c_shipped |    2 +-
>  scripts/kconfig/zconf.y             |    2 +-
>  4 files changed, 21 insertions(+), 17 deletions(-)

Hi Andi,

The patch looks ok, but you forgot your Signed-off-by line?

Michal
