Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZBAJUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZBAJUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 04:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZBAJU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 04:20:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45008 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZBAJUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 04:20:25 -0500
Subject: Re: [PATCH] mm: Fix dirty_bytes/dirty_background_bytes sysctls on
 64bit arches
From: Peter Zijlstra <peterz@infradead.org>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0902010218350.6140@titan.stealer.net>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com>
	 <alpine.LNX.2.00.0902010218350.6140@titan.stealer.net>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 10:19:39 +0100
Message-Id: <1233479979.4787.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-01 at 02:22 +0100, Sven Wegener wrote:
> We need to pass an unsigned long as the minimum, because it gets casted
> to an unsigned long in the sysctl handler. If we pass an int, we'll
> access four more bytes on 64bit arches, resulting in a random minimum
> value.

If that's so, how can any of those other limit values still be good?

> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> ---
>  kernel/sysctl.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 790f9d7..c5ef44f 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -101,6 +101,7 @@ static int two = 2;
>  
>  static int zero;
>  static int one = 1;
> +static unsigned long one_ul = 1;
>  static int one_hundred = 100;
>  
>  /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
> @@ -974,7 +975,7 @@ static struct ctl_table vm_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= &dirty_background_bytes_handler,
>  		.strategy	= &sysctl_intvec,
> -		.extra1		= &one,
> +		.extra1		= &one_ul,
>  	},
>  	{
>  		.ctl_name	= VM_DIRTY_RATIO,
> @@ -995,7 +996,7 @@ static struct ctl_table vm_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= &dirty_bytes_handler,
>  		.strategy	= &sysctl_intvec,
> -		.extra1		= &one,
> +		.extra1		= &one_ul,
>  	},
>  	{
>  		.procname	= "dirty_writeback_centisecs",

