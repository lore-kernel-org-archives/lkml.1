Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbZFVLWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbZFVLWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZFVLWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:22:12 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48456 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZFVLWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:22:11 -0400
Subject: Re: [BUG] timer_migration interface accepts any number as input in
 2.6.30-git9
From: poornima nayak <mpnayak@linux.vnet.ibm.com>
To: arun@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090617102126.GA28647@linux.vnet.ibm.com>
References: <1245229936.3345.67.camel@localhost.localdomain>
	 <20090617102126.GA28647@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 16:52:08 +0530
Message-Id: <1245669728.4368.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun, 

Patch given by you fixes the reported bug.

Regds
Poornima
On Wed, 2009-06-17 at 15:51 +0530, Arun R Bharadwaj wrote:
> * poornima nayak <mpnayak@linux.vnet.ibm.com> [2009-06-17 14:42:16]:
> 
> > Hi
> > 
> > Timer migration interface /proc/sys/kernel/timer_migration in
> > 2.6.30-git9 accepts any numerical value as input.
> > Steps to reproduce 
> > 1. echo -6666666 > /proc/sys/kernel/timer_migration
> > 2. cat /proc/sys/kernel/timer_migration
> > -6666666
> > 
> > 1. echo 44444444444444444444444444444444444444444444444444444444444 > /proc/sys/kernel/timer_migration
> > 2. cat /proc/sys/kernel/timer_migration
> > -1357789412
> > 
> > Expected behavior: Should 'echo: write error: Invalid argument' while
> > setting any value other then 0 & 1
> > 
> > Regards
> > Poornima
> > 
> 
> Hi Poornima,
> 
> Thanks for reporting the bug.
> Hope this patch removes the bug.
> The patch is based against the latest -tip/master.
> 
> --arun
> 
> 
> Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
> ---
>  kernel/sysctl.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux.trees.git/kernel/sysctl.c
> ===================================================================
> --- linux.trees.git.orig/kernel/sysctl.c
> +++ linux.trees.git/kernel/sysctl.c
> @@ -335,7 +335,10 @@ static struct ctl_table kern_table[] = {
>  		.data		= &sysctl_timer_migration,
>  		.maxlen		= sizeof(unsigned int),
>  		.mode		= 0644,
> -		.proc_handler	= &proc_dointvec,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec,
> +		.extra1		= &zero,
> +		.extra2		= &one,
>  	},
>  #endif
>  	{
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

