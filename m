Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZJ2CGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZJ2CGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 22:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZJ2CGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 22:06:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbZJ2CGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 22:06:14 -0400
Subject: Re: [patch 3/3] x86_64, cpa: use only text section in
 set_kernel_text_rw/ro
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20091029024821.164525222@sbs-t61.sc.intel.com>
References: <20091029024820.996634347@sbs-t61.sc.intel.com>
	 <20091029024821.164525222@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 28 Oct 2009 22:06:17 -0400
Message-Id: <1256781977.26028.2139.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 18:46 -0800, Suresh Siddha wrote:
> plain text document attachment (fix_kernel_text_ro_rw.patch)
> set_kernel_text_rw()/set_kernel_text_ro() are marking pages starting
> from _text to __start_rodata as RW or RO.
> 
> With CONFIG_DEBUG_RODATA, there might be free pages (associated with
> padding the sections to 2MB large page boundary) between text
> and rodata sections that are given back to page allocator. So we should
> use only use the start (__text) and end (__stop___ex_table) of the
> text section in set_kernel_text_rw()/set_kernel_text_ro().
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  

I'll go ahead and test this to make sure it does not bust ftrace with an
allyesconfig.

Thanks,

-- Steve


