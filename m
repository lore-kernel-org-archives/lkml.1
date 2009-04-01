Return-Path: <linux-kernel-owner+w=401wt.eu-S932698AbZDATh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbZDATh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbZDAThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:37:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59736 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348AbZDAThH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:37:07 -0400
Date: Wed, 1 Apr 2009 21:36:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Joerg Engel <joern@logfs.org>
Subject: Re: Detailed Stack Information Patch [2/3]
Message-ID: <20090401193639.GB12316@elte.hu>
References: <1238511507.364.62.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238511507.364.62.camel@matrix>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefani Seibold <stefani@seibold.net> wrote:

> +config PROC_STACK_MONITOR
> + 	default y
> +	depends on PROC_STACK
> +	bool "Enable /proc/stackmon detailed stack monitoring"
> + 	help
> +	  This enables detailed monitoring of process and thread stack
> +	  utilization via the /proc/stackmon interface.
> +	  Disabling these interfaces will reduce the size of the kernel by
> +	  approximately 2kb.

Hm, i'm not convinced about this one. Stupid question: what's wrong 
with ulimit -s?

Also, if for some reason you dont want to (or cannot) enforce a 
system-wide stack size ulimit, or it has some limitation that makes 
it impractical for you - if we add what i suggested to the 
/proc/*/maps files, your user-space watchdog daemon could scan those 
periodically and report any excesses and zap the culprit ... right?

	Ingo
