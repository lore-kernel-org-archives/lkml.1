Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbZCaPtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbZCaPtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZCaPtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:49:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35419 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZCaPtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:49:12 -0400
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Joerg Engel <joern@logfs.org>
Subject: Re: Detailed Stack Information Patch [0/3]
From: Andi Kleen <andi@firstfloor.org>
References: <1238511498.364.60.camel@matrix>
Date: Tue, 31 Mar 2009 17:49:05 +0200
In-Reply-To: <1238511498.364.60.camel@matrix> (Stefani Seibold's message of "Tue, 31 Mar 2009 16:58:18 +0200")
Message-ID: <87eiwdn15a.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:
>
> - Get out of virtual memory by creating a lot of threads
>  (f.e. the developer did assign each of them the default size)

The application just fails then? I don't think that needs
a new monitoring tool.

> - Misuse the thread stack for big temporary data buffers

That would be better checked for at compile time
(except for alloca, but that is quite rare)

> - Thread stack overruns

Your method would be racy at best to determine this because
you don't keep track of the worst case, only the current case.

So e.g. if you monitoring app checks once per second the stack
could overflow between your monitoring intervals, but already
have bounced back before the checker comes in.

gcc has support to generate stack overflow checking code,
that would be more reliable. Alternatively you could keep
track of consumption in the VMA that has the stack,  but
that can't handle very large jumps (like f() { char x[1<<30]; } )
The later can only be handled well by the compiler.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
