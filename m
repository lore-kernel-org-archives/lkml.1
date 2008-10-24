Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYJXIzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYJXIzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 04:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYJXIzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 04:55:24 -0400
Received: from ozlabs.org ([203.10.76.45]:45700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYJXIzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:55:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix memory leak and cpumask corruption
Date: Fri, 24 Oct 2008 19:55:29 +1100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
References: <4901564F.7020308@ct.jp.nec.com>
In-Reply-To: <4901564F.7020308@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241955.29400.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 15:59:59 Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Hi Hiroshi,

   Thanks for looking at this!

> On CONFIG_CPUMASK_OFFSTACK enabled kernel, when exiting
> smp_call_function_many() without calling arch_send_call_function_ipi()
> allbutself should be freed.

   That bit's OK, changing the return to "goto out;".

> Also, the memory for allbutself shouldn't be freed when
> arch_send_call_function_ipi() is called.  The memory region will be
> referenced in generic_smp_call_function_interrupt(). And the memory
> will be freed at rcu_free_call_data().

As your next patch shows, this should be solved a different way.  I'll comment 
there.

Cheers,
Rusty.
