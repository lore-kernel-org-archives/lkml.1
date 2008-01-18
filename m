Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYARJeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYARJeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYARJeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:34:01 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40644 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbYARJd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:33:59 -0500
To: salikhmetov@gmail.com
CC: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
In-reply-to: <12006091213248-git-send-email-salikhmetov@gmail.com> (message
	from Anton Salikhmetov on Fri, 18 Jan 2008 01:31:57 +0300)
Subject: Re: [PATCH -v6 1/2] Massive code cleanup of sys_msync()
References: <12006091182260-git-send-email-salikhmetov@gmail.com> <12006091213248-git-send-email-salikhmetov@gmail.com>
Message-Id: <E1JFnbj-0008SD-57@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jan 2008 10:33:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	unsigned long end;
> -	struct mm_struct *mm = current->mm;
> +	int error, unmapped_error;
>  	struct vm_area_struct *vma;
> -	int unmapped_error = 0;
> -	int error = -EINVAL;
> +	struct mm_struct *mm;
>  
> +	error = -EINVAL;

I think you may have misunderstood my last comment.  These are OK:

	struct mm_struct *mm = current->mm;
	int unmapped_error = 0;
	int error = -EINVAL;

This is not so good:

	int error, unmapped_error;

This is the worst:

	int error = -EINVAL, unmapped_error = 0;

So I think the original code is fine as it is.

Othewise patch looks OK now.

Miklos
