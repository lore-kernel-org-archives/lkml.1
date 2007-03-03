Return-Path: <linux-kernel-owner+w=401wt.eu-S1030692AbXCCRiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030692AbXCCRiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 12:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030695AbXCCRiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 12:38:52 -0500
Received: from mail.screens.ru ([213.234.233.54]:46733 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030692AbXCCRiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 12:38:51 -0500
Date: Sat, 3 Mar 2007 20:38:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: John Reiser <jreiser@BitWagon.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
Message-ID: <20070303173834.GB249@tv-sign.ru>
References: <20070301175207.GA849@tv-sign.ru> <20070302034800.GA12530@linux-sh.org> <20070302193219.GA87@tv-sign.ru> <45E894FA.2040103@BitWagon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E894FA.2040103@BitWagon.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, John Reiser wrote:
>
> Oleg Nesterov wrote:
> 
> > Still, I don't understand why we don't pass NEW_AUX_ENT(AT_SYSINFO) when
> > vdso_enabled == 0. We don't need linux-gate.so to use __kernel_vsyscall,
> > we have FIX_VDSO. In that case we should s/PAGE_KERNEL_RO/PAGE_READONLY/
> > of course. I guess the reason is some magic in glibc.
> 
> In the past there were problems where user code could not single-step
> (or even read the code of) such system calls.  Can these two operations
> be performed today with what you propose, particularly if FIX_VDSO is
> near 0xfffff000 ?

No, we can't COW the gate page, it lives in swapper_pg_dir. I am not sure
why we could not read it, we have gate_vma for that.

So, the reason is debugger. Thanks.

Oleg.

