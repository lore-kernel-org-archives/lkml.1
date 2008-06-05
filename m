Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbYFEWGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbYFEWGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYFEWGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:06:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbYFEWGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:06:03 -0400
Date: Thu, 5 Jun 2008 15:05:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: ttuttle@google.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/4] pagemap: Require reads of /proc/pid/pagemap to be
 multiples of 8 (v2 of series)
Message-Id: <20080605150502.77e7ade8.akpm@linux-foundation.org>
In-Reply-To: <1212699119.3953.206.camel@calx>
References: <4ca0a85e0806051138q2a6a6aeav941e46c67ee12bd0@mail.gmail.com>
	<20080605123732.98dc47fb.akpm@linux-foundation.org>
	<1212699119.3953.206.camel@calx>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 15:51:59 -0500
Matt Mackall <mpm@selenic.com> wrote:

> 
> On Thu, 2008-06-05 at 12:37 -0700, Andrew Morton wrote:
> > On Thu, 5 Jun 2008 14:38:10 -0400
> > "Thomas Tuttle" <ttuttle@google.com> wrote:
> > 
> > > This matches the behavior of /proc/kpage{count,flags}, and simplifies
> > > the logic a bit.
> > > 
> > > I also changed out and end in struct pagemapread to be u64* instead of
> > > char*, which makes put_user work the way it was intended.  (Before, it
> > > was only copying the bottom byte of a pagemap entry, because the target
> > > of the copy was a char*.)
> > 
> > This one is for 2.6.25.x?
> 
> This one is for 2.6.26. Something more like this for 2.6.25.x:
> 
> Because put_user bases its copy size on the size of the target pointer,
> not the source, it was copying only 1 byte rather than the intended 8.
> 
> Spotted-by: Thomas Tuttle <ttuttle@google.com>
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> diff -r 5030869d9ded fs/proc/task_mmu.c
> --- a/fs/proc/task_mmu.c	Thu Jun 05 04:01:40 2008 +0000
> +++ b/fs/proc/task_mmu.c	Thu Jun 05 15:45:00 2008 -0500
> @@ -531,7 +531,7 @@
>  		return PM_END_OF_BUFFER;
>  	}
>  
> -	if (put_user(pfn, pm->out))
> +	if (put_user(pfn, (u64 *)pm->out))
>  		return -EFAULT;
>  	pm->out += PM_ENTRY_BYTES;
>  	return 0;
> 
> 

OK.  I can't merge that I guess, so could someome please prepare a
formal patch for the stable guys?  Preferably one which remembers
to add __user to that cast :)
