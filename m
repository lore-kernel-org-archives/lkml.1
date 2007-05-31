Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbXEaMnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbXEaMnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760293AbXEaMnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:43:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:35891 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760276AbXEaMnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:43:09 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
References: <20070530140025.917261793@polymtl.ca>
	<20070530140229.811672406@polymtl.ca>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 May 2007 15:39:44 +0200
In-Reply-To: <20070530140229.811672406@polymtl.ca>
Message-ID: <p736469dsdb.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
>  	}
> -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> +	cond_call(profile_on,
> +		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));

Would it be possible to use a syntax like

        if (unlikely_cond_call(variable)) {     (or better name) 
                ...
        } 

instead? I think that would be much nicer to read than having
code in a macro argument

-Andi
