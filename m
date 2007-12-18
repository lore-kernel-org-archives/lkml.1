Return-Path: <linux-kernel-owner+w=401wt.eu-S1761325AbXLRGqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325AbXLRGqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 01:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXLRGqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 01:46:11 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:44638 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751002AbXLRGqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 01:46:10 -0500
Message-ID: <47676CB7.4060203@in.ibm.com>
Date: Tue, 18 Dec 2007 12:16:15 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: ananth@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [RFC] [patch 1/2] add non_init_kernel_text_address
References: <200712141225.30099.srinivasa@in.ibm.com> <20071213230916.cd30de8c.akpm@linux-foundation.org> <20071214075106.GA13249@in.ibm.com> <200712181557.35712.rusty@rustcorp.com.au>
In-Reply-To: <200712181557.35712.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 14 December 2007 18:51:06 Ananth N Mavinakayanahalli wrote:
>> On Thu, Dec 13, 2007 at 11:09:16PM -0800, Andrew Morton wrote:
>>> regular_kernel_text_address()?  Dunno.
>> Sounds better :-)
> 
> The better answer was to invert it and use "discarded_kernel_text_address()",
> which is what you actually care about (rather than the details of whether it
> was init or not).

Requirement is to ensure the address is really a kernel_text address and doesn't
lie in __init section. Hence I used persistent_kernel_text_address().

> 
> However, you have, in fact, located a potential bug.  If someone were to
> kmalloc module text, then symbol_put() could fail.

I don't think so, symbol_put() makes use of lookup_symbol() within __start_ksymtab
and  stop_ksymtab. 

> 
> How's this?
> ---
> Don't report discarded init pages as kernel text.
> 
> In theory this could cause a bug in symbol_put() if an arch used for
> a module: we might think the symbol belongs to the core kernel.

Yes, usage of symbol_put_addr() cause the BUG() if it fails
to find the address in core kernel.
> 
> The downside is that this might make backtraces through (discarded)
> init functions harder to read on some archs.
> 

I think it is better to make use of new function than sacrificing 
__init function symbol information in backtrace.

Thanks
 Srinivasa DS
