Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbYHGNSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbYHGNSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbYHGNSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:18:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYHGNSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:18:01 -0400
Date: Thu, 7 Aug 2008 09:17:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 3/6] kexec jump: remove duplication of
	kexec_restart_prepare()
Message-ID: <20080807131742.GC27783@redhat.com>
References: <1218099928.5164.34.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218099928.5164.34.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 05:05:28PM +0800, Huang Ying wrote:
> Call kernel_restart_prepare() in kernel_kexec() instead of duplicating
> the code.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  include/linux/reboot.h |    1 +
>  kernel/kexec.c         |    6 +-----
>  kernel/sys.c           |    2 +-
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> --- a/include/linux/reboot.h
> +++ b/include/linux/reboot.h
> @@ -59,6 +59,7 @@ extern void machine_crash_shutdown(struc
>   * Architecture independent implemenations of sys_reboot commands.
>   */
>  
> +extern void kernel_restart_prepare(char *cmd);
>  extern void kernel_restart(char *cmd);
>  extern void kernel_halt(void);
>  extern void kernel_power_off(void);
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -274,7 +274,7 @@ void emergency_restart(void)
>  }
>  EXPORT_SYMBOL_GPL(emergency_restart);
>  
> -static void kernel_restart_prepare(char *cmd)
> +void kernel_restart_prepare(char *cmd)
>  {
>  	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
>  	system_state = SYSTEM_RESTART;
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1472,11 +1472,7 @@ int kernel_kexec(void)
>  	} else
>  #endif
>  	{
> -		blocking_notifier_call_chain(&reboot_notifier_list,
> -					     SYS_RESTART, NULL);
> -		system_state = SYSTEM_RESTART;
> -		device_shutdown();
> -		sysdev_shutdown();
> +		kernel_restart_prepare(NULL);
>  		printk(KERN_EMERG "Starting new kernel\n");
>  		machine_shutdown();
>  	}

Looks good to me. 

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
