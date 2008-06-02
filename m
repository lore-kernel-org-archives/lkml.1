Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYFBLuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYFBLuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbYFBLun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:50:43 -0400
Received: from gw.goop.org ([64.81.55.164]:58477 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbYFBLum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:50:42 -0400
Message-ID: <4843DE6C.8030501@goop.org>
Date: Mon, 02 Jun 2008 12:50:04 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH 08 of 12] xen-console: add save/restore
References: <patchbomb.1211550067@localhost> <d9561e802a69a3ca269c.1211550075@localhost> <20080602111720.GC18586@elte.hu>
In-Reply-To: <20080602111720.GC18586@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> -tip testing found the following xen-console symbols trouble:
>
>  ERROR: "console_drivers" [drivers/video/xen-fbfront.ko] undefined!
>  ERROR: "get_phys_to_machine" [drivers/video/xen-fbfront.ko] undefined!
>  ERROR: "get_phys_to_machine" [drivers/net/xen-netfront.ko] undefined!
>  ERROR: "get_phys_to_machine" [drivers/input/xen-kbdfront.ko] undefined!
>
> with:
>
>   http://redhat.com/~mingo/misc/config-Mon_Jun__2_12_26_38_CEST_2008.bad
>
> get_phys_to_machine can indeed be exported but i'm less sure about the 
> console_drivers export ... The temporary fix below resolves it for now.
>   

Exporting "get_phys_to_machine" is definitely the right thing to do, 
though it might be an idea to put it in the xen_ namespace.

The console changes are Markus' territory.  Markus?

Thanks,
    J

> 	Ingo
>
> ------------->
> Subject: xen: build fixes
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon Jun 02 13:13:04 CEST 2008
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/xen/mmu.c |    1 +
>  kernel/printk.c    |    2 ++
>  2 files changed, 3 insertions(+)
>
> Index: linux/arch/x86/xen/mmu.c
> ===================================================================
> --- linux.orig/arch/x86/xen/mmu.c
> +++ linux/arch/x86/xen/mmu.c
> @@ -136,6 +136,7 @@ unsigned long get_phys_to_machine(unsign
>  	idx = p2m_index(pfn);
>  	return p2m_top[topidx][idx];
>  }
> +EXPORT_SYMBOL_GPL(get_phys_to_machine);
>  
>  static void alloc_p2m(unsigned long **pp, unsigned long *mfnp)
>  {
> Index: linux/kernel/printk.c
> ===================================================================
> --- linux.orig/kernel/printk.c
> +++ linux/kernel/printk.c
> @@ -76,6 +76,8 @@ EXPORT_SYMBOL(oops_in_progress);
>  static DECLARE_MUTEX(console_sem);
>  static DECLARE_MUTEX(secondary_console_sem);
>  struct console *console_drivers;
> +EXPORT_SYMBOL_GPL(console_drivers);
> +
>  /*
>   * This is used for debugging the mess that is the VT code by
>   * keeping track if we have the console semaphore held. It's
>   

