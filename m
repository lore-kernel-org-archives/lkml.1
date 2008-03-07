Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbYCGJDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbYCGJDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761180AbYCGJCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:02:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762816AbYCGJCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:02:31 -0500
Date: Fri, 7 Mar 2008 01:02:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] add time_after_now and other macros which compare
 with jiffies
Message-Id: <20080307010228.de6700b5.akpm@linux-foundation.org>
In-Reply-To: <20080307030901.GA4375@darkstar.te-china.tietoenator.com>
References: <20080307030901.GA4375@darkstar.te-china.tietoenator.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 11:09:01 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> Most of time_after like macros users just compare jiffies and
> another number, so here add some other _now macros to do it.
> 
> Another aproach is changing original time_ macros to use jiffies to compare,
> add a generic compare macro like time_compare(a, b)
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> 
> ---
> jiffies.h |    8 ++++++++
> 1 file changed, 8 insertions(+)
> 
> diff -upr linux/include/linux/jiffies.h linux.new/include/linux/jiffies.h
> --- linux/include/linux/jiffies.h	2008-03-07 10:40:04.000000000 +0800
> +++ linux.new/include/linux/jiffies.h	2008-03-07 10:50:12.000000000 +0800
> @@ -134,6 +134,14 @@ static inline u64 get_jiffies_64(void)
>  	 ((__s64)(a) - (__s64)(b) >= 0))
>  #define time_before_eq64(a,b)	time_after_eq64(b,a)
>  
> +#define time_after_now(a) time_after(jiffies, a)
> +
> +#define time_before_now(a) time_before(jiffies, a)
> +
> +#define time_after_eq_now(a) time_after_eq(jiffies, a)
> +
> +#define time_before_eq_now(a) time_before_eq(jiffies, a)
> +
>  /*
>   * Have the 32 bit jiffies value wrap 5 minutes after boot
>   * so jiffies wrap bugs show up earlier.

time_after() and friends drive me nutty.  I *always* have to go and look at
the definition to make sure that people got the args the right way around.

(does that)

> * time_after(a,b) returns true if the time a is after time b.

so, umm, I think you got it backwards.  Your time_after_now(a) will return
true if jiffies (ie: now) is after `a'.  ie: if a is before or equal to
"now".

All this shouldn't be as hard as it is.

One lesson we can learn from this: whatever we do, it needs careful
commenting.  Your change doesn't do that.
