Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbXIHQMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbXIHQMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXIHQM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:12:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:46774 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbXIHQM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:12:29 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Scheduler Profiling - Use Immediate Values
References: <20070906200537.GA5999@Krystal>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Sep 2007 18:12:27 +0200
In-Reply-To: <20070906200537.GA5999@Krystal>
Message-ID: <p73bqcd9lw4.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
>  
> -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> +	immediate_if (&sched_profiling)

I must say I really dislike immediate_if(). You complained earlier
that something breaks coloring, but adding such macros will definitely
break a lot of editors (especially if you use it without {} like here)

It would be much nicer and readable to just use if 
(unlikely(immediate_read(&x)) or if you prefer to hide the unlikely
if (immediate_bool_test(&x)) with an implicit unlikely().

-Andi
