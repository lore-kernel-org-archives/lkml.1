Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYKZVTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYKZVTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYKZVT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:19:28 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33791 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754813AbYKZVT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:19:26 -0500
Date: Wed, 26 Nov 2008 15:18:41 -0600
From: Cliff Wickman <cpw@sgi.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: uv bau interrupt -- use proper interrupt number
Message-ID: <20081126211841.GA20309@sgi.com>
References: <20081126210210.GA8671@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126210210.GA8671@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 12:02:10AM +0300, Cyrill Gorcunov wrote:
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> CC: Andi Kleen <andi@firstfloor.org>
> ---
>  arch/x86/kernel/entry_64.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
> +++ linux-2.6.git/arch/x86/kernel/entry_64.S
> @@ -945,7 +945,7 @@ apicinterrupt IRQ_MOVE_CLEANUP_VECTOR \
>  	irq_move_cleanup_interrupt smp_irq_move_cleanup_interrupt
>  #endif
>  
> -apicinterrupt 220 \
> +apicinterrupt UV_BAU_MESSAGE \
>  	uv_bau_message_intr1 uv_bau_message_interrupt
>  apicinterrupt LOCAL_TIMER_VECTOR \
>  	apic_timer_interrupt smp_apic_timer_interrupt
> --

The interrupt handler does not use the hardcoded 220, but
the declaration should indeed be fixed as above.
(such a fix was once submitted
 http://marc.info/?l=linux-kernel&m=122350309029050&w=2  but didn't
 go anywhere)
Thanks for the follow-up.

-Cliff
-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
