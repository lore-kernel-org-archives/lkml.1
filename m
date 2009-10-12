Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZJLSLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZJLSLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbZJLSLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:11:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34902 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbZJLSLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:11:14 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFC][PATCH] kmap_atomic_push
From: Andi Kleen <andi@firstfloor.org>
References: <1255016123.17055.17.camel@laptop>
Date: Mon, 12 Oct 2009 20:10:37 +0200
In-Reply-To: <1255016123.17055.17.camel@laptop> (Peter Zijlstra's message of "Thu, 08 Oct 2009 17:35:23 +0200")
Message-ID: <87ws30fppe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
> -
> -static inline void debug_kmap_atomic(enum km_type type)
> +static inline int kmap_atomic_push_idx(void)
>  {
> +	int idx = __get_cpu_var(__kmap_atomic_depth)++;

The counter needs to be of local atomic type. Otherwise kmap_atomic cannot
be done from interrupts/nmis, which is unfortunately occasionally needed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
