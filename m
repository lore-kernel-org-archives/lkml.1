Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbYKWLVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbYKWLVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYKWLUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:20:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32861 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbYKWLUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:20:53 -0500
Date: Sun, 23 Nov 2008 12:20:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH] tracing/stack-tracer: avoid races accessing file
Message-ID: <20081123112043.GA29663@elte.hu>
References: <20081123110714.GE30453@elte.hu> <1227438490-23259-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1227438490-23259-1-git-send-email-edwintorok@gmail.com>
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


* Török Edwin <edwintorok@gmail.com> wrote:

> ---
>  kernel/trace/trace.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4c3bd82..48d1536 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1470,13 +1470,13 @@ static inline int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
>  			file = vma->vm_file;
>  			vmstart = vma->vm_start;
>  		}
> +		if (file) {
> +			ret = trace_seq_path(s, &file->f_path);
> +			if (ret)
> +				ret = trace_seq_printf(s, "[+0x%lx]", ip - vmstart);
> +		}
>  		up_read(&mm->mmap_sem);
>  	}
> -	if (file) {
> -		ret = trace_seq_path(s, &file->f_path);
> -		if (ret)
> -			ret = trace_seq_printf(s, "[+0x%lx]", ip - vmstart);
> -	}

applied to tip/tracing/stack-tracer, thanks Edwin!

	Ingo
