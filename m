Return-Path: <linux-kernel-owner+w=401wt.eu-S1761591AbYAKPzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591AbYAKPzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYAKPzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:55:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbYAKPzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:55:08 -0500
Date: Fri, 11 Jan 2008 10:55:00 -0500
From: Rik van Riel <riel@redhat.com>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, ksm@42.dk, staubach@redhat.com,
       jesper.juhl@gmail.com
Subject: Re: [PATCH 1/2][RFC][BUG] msync: massive code cleanup of
 sys_msync()
Message-ID: <20080111105500.4a35e63f@bree.surriel.com>
In-Reply-To: <1200011922.19293.92.camel@codedot>
References: <1200006638.19293.42.camel@codedot>
	<1200011922.19293.92.camel@codedot>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 03:38:42 +0300
Anton Salikhmetov <salikhmetov@gmail.com> wrote:

> @@ -33,71 +34,60 @@ asmlinkage long sys_msync(unsigned long start, size_t len, int flags)
>  	unsigned long end;
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *vma;
> -	int unmapped_error = 0;
> -	int error = -EINVAL;
> +	int error = 0, unmapped_error = 0;
> +
> +	if ((flags & ~(MS_ASYNC | MS_INVALIDATE | MS_SYNC)) ||
> +			(start & ~PAGE_MASK) ||
> +			((flags & MS_ASYNC) && (flags & MS_SYNC)))
> +		return -EINVAL;
>  
> -	if (flags & ~(MS_ASYNC | MS_INVALIDATE | MS_SYNC))
> -		goto out;
> -	if (start & ~PAGE_MASK)
> -		goto out;
> -	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
> -		goto out;
> -	error = -ENOMEM;

Personally I prefer having these error checks separated out,
but that's just my opinion :)

I like the rest of your cleanup patch.

-- 
All rights reversed.
