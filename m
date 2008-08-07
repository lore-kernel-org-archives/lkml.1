Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYHGNFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYHGNFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYHGNFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:05:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYHGNFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:05:05 -0400
Date: Thu, 7 Aug 2008 09:04:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 1/6] kexec jump: clean up #ifdef and comments
Message-ID: <20080807130401.GA27783@redhat.com>
References: <1218099923.5164.32.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218099923.5164.32.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 05:05:23PM +0800, Huang Ying wrote:
> Move if (kexec_image->preserve_context) { ... } into #ifdef
> CONFIG_KEXEC_JUMP to make code looks cleaner.
> 
> Fix no longer correct comments of kernel_kexec().
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  kernel/kexec.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1427,8 +1427,6 @@ static int __init crash_save_vmcoreinfo_
>  module_init(crash_save_vmcoreinfo_init)
>  
>  /**
> - *	kernel_kexec - reboot the system
> - *
>   *	Move into place and start executing a preloaded standalone
>   *	executable.  If nothing was preloaded return an error.
>   */
> @@ -1443,8 +1441,8 @@ int kernel_kexec(void)
>  		goto Unlock;
>  	}
>  
> -	if (kexec_image->preserve_context) {
>  #ifdef CONFIG_KEXEC_JUMP
> +	if (kexec_image->preserve_context) {
>  		mutex_lock(&pm_mutex);
>  		pm_prepare_console();
>  		error = freeze_processes();
> @@ -1471,8 +1469,9 @@ int kernel_kexec(void)
>  		if (error)
>  			goto Enable_irqs;
>  		save_processor_state();
> +	} else
>  #endif
> -	} else {
> +	{
>  		blocking_notifier_call_chain(&reboot_notifier_list,
>  					     SYS_RESTART, NULL);
>  		system_state = SYSTEM_RESTART;
> @@ -1484,8 +1483,8 @@ int kernel_kexec(void)
>  
>  	machine_kexec(kexec_image);
>  
> -	if (kexec_image->preserve_context) {
>  #ifdef CONFIG_KEXEC_JUMP
> +	if (kexec_image->preserve_context) {
>  		restore_processor_state();
>  		device_power_up(PMSG_RESTORE);
>   Enable_irqs:
> @@ -1499,8 +1498,8 @@ int kernel_kexec(void)
>   Restore_console:
>  		pm_restore_console();
>  		mutex_unlock(&pm_mutex);
> -#endif
>  	}
> +#endif
>  
>   Unlock:
>  	xchg(&kexec_lock, 0);

Thanks Huang. Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
