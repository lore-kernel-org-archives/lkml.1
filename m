Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbYCHIhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbYCHIhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 03:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYCHIhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 03:37:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbYCHIhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 03:37:05 -0500
Date: Sat, 8 Mar 2008 09:36:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "G. Vaughan" <gvaughan@jpl.nasa.gov>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Fix check after use in kernel/exit.c
Message-ID: <20080308083637.GA23555@elte.hu>
References: <20080308.161105.253167431.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308.161105.253167431.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* WANG Cong <xiyou.wangcong@gmail.com> wrote:

> mm_release won't check the mm_struct pointer, so it should be checked 
> before this call.

> @@ -582,9 +582,9 @@ static void exit_mm(struct task_struct * tsk)
>  {
>  	struct mm_struct *mm = tsk->mm;
>  
> -	mm_release(tsk, mm);
>  	if (!mm)
>  		return;
> +	mm_release(tsk, mm);

thanks, applied. I'm wondering why this never seems to hit in practice.

	Ingo
