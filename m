Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbYASVbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbYASVbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYASVbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:31:40 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50014 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYASVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:31:40 -0500
Date: Sat, 19 Jan 2008 22:31:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
       akpm <akpm@linux-foundation.org>, johannes@sipsolutions.net
Subject: Re: [PATCH] hrtimer: fix section mismatch
Message-ID: <20080119213146.GE29070@uranus.ravnborg.org>
References: <20080119115710.520090e4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119115710.520090e4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 11:57:10AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch in hrtimer.c:
> 
> WARNING: vmlinux.o(.text+0x50c61): Section mismatch: reference to .init.text: (between 'hrtimer_cpu_notify' and 'down_read_trylock')
> 
> Noticed by Johannes Berg and confirmed by Sam Ravnborg.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> ---
>  kernel/hrtimer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.24-rc8-git2.orig/kernel/hrtimer.c
> +++ linux-2.6.24-rc8-git2/kernel/hrtimer.c
> @@ -1378,7 +1378,7 @@ sys_nanosleep(struct timespec __user *rq
>  /*
>   * Functions related to boot-time initialization:
>   */
> -static void __devinit init_hrtimers_cpu(int cpu)
> +static void __cpuinit init_hrtimers_cpu(int cpu)
>  {
>  	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
>  	int i;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
