Return-Path: <linux-kernel-owner+w=401wt.eu-S1761931AbYESUWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761931AbYESUWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYESUWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:22:39 -0400
Received: from mga10.intel.com ([192.55.52.92]:15463 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751618AbYESUWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:22:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,511,1204531200"; 
   d="scan'208";a="566329144"
Message-ID: <4831E18D.6040100@linux.intel.com>
Date: Mon, 19 May 2008 13:22:37 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] x86: don't destroy %rbp on kernel-mode faults
References: <20080519200230.GA12210@damson.getinternet.no>
In-Reply-To: <20080519200230.GA12210@damson.getinternet.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hi,
> 
> The RFC part of this patch is: Does anybody see why touching %rcx would
> be bad? It certainly looks like %ecx is free. This fixes the stacktrace
> problem I was seeing, and Pekka tested a bootup to userspace. (Pekka also
> did half of the debugging. When will git allow multiple authors for a
> patch? :-))
> 
> 
> Vegard
> 
> 
> From b1cbf24fcd05aa5ed2e610c80c06bc519d3188f7 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Mon, 19 May 2008 21:39:44 +0200
> Subject: [PATCH] x86: don't destroy %rbp on kernel-mode faults
> 
> From the code:
> 
>     B stepping K8s sometimes report an truncated RIP for IRET exceptions
>     returning to compat mode. Check for these here too.
> 
> The code then proceeds to truncate the upper 32 bits of %rbp. This means
> that when do_page_fault() is finally called, its prologue,
> 
>     do_page_fault:
>         push %rbp
>         movl %rsp, %rbp
> 
> will put the truncated base pointer on the stack. This means that the
> stack tracer will not be able to follow the base-pointer changes and
> will see all subsequent stack frames as unreliable.
> 
> This patch changes the code to use a different register (%rcx) for the
> checking and leaves %rbp untouched.
> 
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

looks good to me; good debugging!

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
