Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbYARFTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbYARFTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYARFT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:19:29 -0500
Received: from ro-out-1112.google.com ([72.14.202.178]:25413 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYARFT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:19:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jf48Lk1B0q3io8viaEbb8cA11G3p8joVw7ptEEaYvADFWoZRF2+FM7TndSACgfhaeqivtqlciHVNntfZi3wYBrTC/YG2YpXjZiAmvD8/xQnonx7dhQwHIITTHSa82qQyktf0XomQyTyis9SWn4k2iZdRO4XiY7AXPqIg6wFCvpQ=
Date: Fri, 18 Jan 2008 13:18:07 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Make kthread_create and kthread_run typesafe
Message-ID: <20080118051807.GB2559@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200801181151.40141.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181151.40141.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 11:51:39AM +1100, Rusty Russell wrote:
>With a little macro ugliness, we can make kthread_create() and
>kthread_run() typesafe: avoid the casts to and from void *.  To do
>this we use a temporary function pointer which takes the type of the
>data as a callback: if the function doesn't match, we get:
>
>	warning: initialization from incompatible pointer type
>
>It's actually slightly over-strict, since a void * would be compatible
>with any function type, but there's only one such case in the kernel
>anyway.

{snip}

>+#define kthread_create(threadfn, data, namefmt...) ({		\
>+	int (*_threadfn)(typeof(data)) = (threadfn);		\
>+	__kthread_create((void *)_threadfn, (data), namefmt);	\
>+})
>+
>+struct task_struct *__kthread_create(int (*threadfn)(void *data),
>+				     void *data,
>+				     const char namefmt[], ...);

Rusty, excellent work!!

I really like this. It is a good trick, neat and clean.
Thanks.

