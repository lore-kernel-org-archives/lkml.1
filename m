Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYIVLv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYIVLv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYIVLvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:51:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60806 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYIVLvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:51:16 -0400
Date: Mon, 22 Sep 2008 13:50:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: markus.t.metzger@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Roland McGrath <roland@redhat.com>
Subject: Re: [patch] x86, ptrace: void dopiness
Message-ID: <20080922115058.GB14301@elte.hu>
References: <20080919145250.A6000@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919145250.A6000@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0925]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> +++ gits.x86/arch/x86/kernel/ptrace.c	2008-09-19 13:53:02.%N +0200
> @@ -738,7 +738,7 @@
>  		unsigned int sig = 0;
>  
>  		/* we ignore the error in case we were not tracing child */
> -		(void)ds_release_bts(child);
> +		ds_release_bts(child);

hm, here the cast is OK because we actually ignore the return value.

> @@ -947,7 +947,7 @@
>  	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
>  #endif
>  #ifdef CONFIG_X86_PTRACE_BTS
> -	(void)ds_release_bts(child);
> +	ds_release_bts(child);

is it right/intentional here?

	Ingo
