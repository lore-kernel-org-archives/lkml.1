Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYCEPft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYCEPft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYCEPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:35:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41644 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbYCEPfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:35:40 -0500
Date: Wed, 5 Mar 2008 16:35:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephan Diestelhorst <langer_mann@web.de>
Cc: davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Message-ID: <20080305153520.GB19300@elte.hu>
References: <200803051559.09962.langer_mann@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803051559.09962.langer_mann@web.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephan Diestelhorst <langer_mann@web.de> wrote:

> @@ -184,7 +184,7 @@ static void speedstep_set_state (unsigne
>  		__asm__ __volatile__(
>  			"movl $0, %%edi\n"
>  			"out %%al, (%%dx)\n"
> -			: "=b" (new_state), "=D" (result)
> +			: "=b" (new_state), "=D" (result), "=c" (ecx_clobber)
>  			: "a" (command), "b" (function), "c" (state), "d" (smi_port), "S" (0)
>  			);

stupid suggestion: why not do a pusha/popa around those instructions, to 
make sure everything is restored? This isnt a fastpath and being 
conservative about SMI side-effects cannot hurt ...

	Ingo
