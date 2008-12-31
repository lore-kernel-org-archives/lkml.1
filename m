Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYLaICB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYLaICB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYLaIBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:01:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbYLaIBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:01:51 -0500
Date: Wed, 31 Dec 2008 00:01:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter W Morreale <pmorreale@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add /proc controls for pdflush threads
Message-Id: <20081231000148.6a2f8e3f.akpm@linux-foundation.org>
In-Reply-To: <20081230231233.10427.11443.stgit@hermosa.site>
References: <20081230231152.10427.50620.stgit@hermosa.site>
	<20081230231233.10427.11443.stgit@hermosa.site>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 16:12:33 -0700 Peter W Morreale <pmorreale@novell.com> wrote:

> From: \"Peter W. Morreale\" <pmorreale@novell.com>
> 
> This patch adds /proc entries to give the admin the ability to
> control the minimum and maximum number of pdflush threads.  This allows
> finer control of pdflush on both large and small machines.
> 
> The patch adds '/proc/sys/vm/nr_pdflush_threads_min' and
> '/proc/sys/vm/nr_pdflush_threads_max' with r/w permissions.

Why is this needed?  Where's the benefit?  What observations led you to
develop this patch?  etc.

> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -205,6 +205,8 @@ enum
>  	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
>  	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
>  	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
> +	VM_NR_PDFLUSH_THREADS_MAX=36, /* nr_pdflush_threads_max */
> +	VM_NR_PDFLUSH_THREADS_MIN=37, /* nr_pdflush_threads_min */
>  };

We don't do this any more...

>  		.proc_handler	= &proc_dointvec,
>  	},
>  	{
> +		.ctl_name	= VM_NR_PDFLUSH_THREADS_MIN,

please just use CTL_UNNUMBERED here.


