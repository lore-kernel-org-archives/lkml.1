Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZE2Anz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZE2Anz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 20:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZE2Anr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 20:43:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:51427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZE2Anr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 20:43:47 -0400
Message-ID: <4A1F2E6E.6030105@novell.com>
Date: Fri, 29 May 2009 09:38:06 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: percpu memory setup and num_possible_cpus() vs. nr_cpu_ids
References: <4A1EBA000200007800003197@vpn.id2.novell.com>
In-Reply-To: <4A1EBA000200007800003197@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

Jan Beulich wrote:
> Tejun,
> 
> this code of yours, as I learned the hard way during some Xen kernel work,
> assumes that cpu_possible_map is not sparse. While on native x86 this is
> certainly true, I wonder whether such a dependency should really exist in
> architecture neutral code. Below, for reference, the places I needed to
> change (4k allocator only). However, there are more instances of this in the
> other allocators - those seem more problematic, as they directly drive input
> to alloc_bootmem() (hence a lot of memory could be wasted, or allocation
> could even fail, with a very sparse cpu_possible_map if one would simply
> also use nr_cpu_ids here). In the remap (x86 - under the assumption that
> if this change gets made, it should also be made in x86 code, albeit not
> directly affected) allocator's case things may not be that bad, since the
> memory gets freed again at the end of setup_pcpu_remap().

There's other related larger issue.  It looks like possible but
offline configuration can be quite common with virtualization and
allocating for all possible cpus on boot can waste problematic amount
of space, so the plan is to allocate only for online cpus on boot and
allocate the rest as cpus come online.  This will require audit of
percpu users and probably a new cpumask representing cpus which have
ever been up.

The issue you're describing should be solved when the above is
implemented, right?

Thanks.

-- 
tejun
