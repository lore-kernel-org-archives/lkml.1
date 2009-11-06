Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbZKFXGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbZKFXGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758659AbZKFXGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:06:47 -0500
Received: from outbound-mail-308.bluehost.com ([67.222.53.254]:50401 "HELO
	outbound-mail-308.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758590AbZKFXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:06:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=od71QsxFV/FiDuLIeuNkfNpeE/1r8RMGnhRPFbQvohzGwxaSbqsRlSg3pEPFexmuEZUg4+tQ5SUGgWtUp98Hn6FIHP9KuXFnGvv1ReAGhfbN05iL4Yee0dxx1CGADhNE;
Date: Fri, 6 Nov 2009 15:06:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 05/16] pci: Replace old style lock initializer
Message-ID: <20091106150656.7422a47b@jbarnes-piketon>
In-Reply-To: <20091106223806.601092947@linutronix.de>
References: <20091106223547.784916750@linutronix.de>
	<20091106223806.601092947@linutronix.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Nov 2009 22:41:23 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> SPIN_LOCK_UNLOCKED is deprecated. Use DEFINE_SPINLOCK instead.
> 
> Make the lock static while at it.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/pci/pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -2590,7 +2590,7 @@ int pci_set_vga_state(struct pci_dev *de
>  
>  #define RESOURCE_ALIGNMENT_PARAM_SIZE COMMAND_LINE_SIZE
>  static char resource_alignment_param[RESOURCE_ALIGNMENT_PARAM_SIZE]
> = {0}; -spinlock_t resource_alignment_lock = SPIN_LOCK_UNLOCKED;
> +static DEFINE_SPINLOCK(resource_alignment_lock);
>  
>  /**
>   * pci_specified_resource_alignment - get resource alignment
> specified by user.

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
