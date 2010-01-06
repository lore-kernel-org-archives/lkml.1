Return-Path: <linux-kernel-owner+w=401wt.eu-S933024Ab0AFXKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab0AFXKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940Ab0AFXKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:10:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932926Ab0AFXKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:10:01 -0500
Date: Wed, 6 Jan 2010 15:09:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>,
       David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] Add BUILD_BUG_ON_NOT_POWER_OF_2()
Message-Id: <20100106150928.68819f8c.akpm@linux-foundation.org>
In-Reply-To: <adaeim2supb.fsf_-_@roland-alpha.cisco.com>
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
	<20100106123306.ac85e557.akpm@linux-foundation.org>
	<aday6kbt14a.fsf@roland-alpha.cisco.com>
	<20100106134232.0025e818.akpm@linux-foundation.org>
	<adaeim2supb.fsf_-_@roland-alpha.cisco.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jan 2010 15:02:40 -0800
Roland Dreier <rdreier@cisco.com> wrote:

> Fair enough... here's your suggestion of BUILD_BUG_ON_NOT_POWER_OF_2().
> <linux/kernel.h> does seem to be going the way of a gazillion very
> specific helper macros, so I guess this fits right in.
> 
>  include/linux/kernel.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3fc9f5a..a1b6652 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -734,6 +734,10 @@ struct sysinfo {
>  /* Force a compilation error if condition is constant and true */
>  #define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
>  
> +/* Force a compilation error if expression is not a power of 2 */
> +#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
> +	BUILD_BUG_ON(((n) != 0 && (((n) & ((n) - 1)) == 0)))
> +
>  /* Force a compilation error if condition is true, but also produce a
>     result (of value 0 and type size_t), so the expression can be used
>     e.g. in a structure initializer (or where-ever else comma expressions

ok..  I'll give it a week or so for better ideas to turn up then I'll
send this Linuswards so that ongoing work can use it.

