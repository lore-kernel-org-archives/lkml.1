Return-Path: <linux-kernel-owner+w=401wt.eu-S966351AbXDGVZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966351AbXDGVZE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 17:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966353AbXDGVZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 17:25:04 -0400
Received: from pop5-1.us4.outblaze.com ([205.158.62.125]:32954 "HELO
	pop5-1.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966352AbXDGVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 17:25:00 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2007 17:25:00 EDT
Subject: Re: [PATCH -mm] freezer: Remove PF_NOFREEZE from handle_initrd
From: Nigel Cunningham <ncunningham@linuxmail.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200704071814.25588.rjw@sisk.pl>
References: <200704071814.25588.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 08 Apr 2007 07:18:16 +1000
Message-Id: <1175980696.10725.12.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-04-07 at 18:14 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make handle_initrd() call try_to_freeze() in a suitable place instead of setting
> PF_NOFREEZE for the current task.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  init/do_mounts_initrd.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.21-rc6/init/do_mounts_initrd.c
> ===================================================================
> --- linux-2.6.21-rc6.orig/init/do_mounts_initrd.c
> +++ linux-2.6.21-rc6/init/do_mounts_initrd.c
> @@ -55,11 +55,12 @@ static void __init handle_initrd(void)
>  	sys_mount(".", "/", NULL, MS_MOVE, NULL);
>  	sys_chroot(".");
>  
> -	current->flags |= PF_NOFREEZE;
>  	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
>  	if (pid > 0) {
> -		while (pid != sys_wait4(-1, NULL, 0, NULL))
> +		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
> +			try_to_freeze();
>  			yield();
> +		}
>  	}
>  
>  	/* move initrd to rootfs' /old */

ACK.

Regards,

Nigel

