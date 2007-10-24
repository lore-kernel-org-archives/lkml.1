Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbXJXSW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbXJXSW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbXJXSWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:22:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41247 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569AbXJXSWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:22:18 -0400
Date: Wed, 24 Oct 2007 20:22:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@kernel.org>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make kernel_shutdown_prepare() static
Message-ID: <20071024182226.GC5093@elf.ucw.cz>
References: <20071024162345.GV30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024162345.GV30533@stusta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-10-24 18:23:45, Adrian Bunk wrote:
> kernel_shutdown_prepare() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

ACK.

> diff --git a/include/linux/reboot.h b/include/linux/reboot.h
> index 85ea63f..b93b541 100644
> --- a/include/linux/reboot.h
> +++ b/include/linux/reboot.h
> @@ -59,8 +59,6 @@ extern void machine_crash_shutdown(struct pt_regs *);
>   * Architecture independent implemenations of sys_reboot commands.
>   */
>  
> -extern void kernel_shutdown_prepare(enum system_states state);
> -
>  extern void kernel_restart(char *cmd);
>  extern void kernel_halt(void);
>  extern void kernel_power_off(void);
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 304b541..4c77ed2 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -315,7 +315,7 @@ static void kernel_kexec(void)
>  #endif
>  }
>  
> -void kernel_shutdown_prepare(enum system_states state)
> +static void kernel_shutdown_prepare(enum system_states state)
>  {
>  	blocking_notifier_call_chain(&reboot_notifier_list,
>  		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
