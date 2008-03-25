Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbYCYIMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbYCYIMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYCYIM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:12:26 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10246 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbYCYIMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:12:24 -0400
Date: Tue, 25 Mar 2008 09:12:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Message-ID: <20080325081219.GO15355@kernel.dk>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com> <20080321183149.GB15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE1387F@orsmsx424.amr.corp.intel.com> <20080322122903.GD15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE5B76D@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE5B76D@orsmsx424.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24 2008, Luck, Tony wrote:
> > Funky, how does accessing other CPU's per-cpu variables work on ia64
> > then? Perhaps I made some false assumptions.
> 
> Having scared you to death with some of the strange weirdness of
> ia64 ... it turns out that you made a trivial typo in the ia64
> specific part of the patch ... see below.
> 
> With this patch and a hack to call init_call_single_data() early
> enough the patch boots fine on ia64.
> 
> -Tony
> 
> commit 8ffe2551f04e55176f7f7935c5a3395cc641d514
> Author: Tony Luck <tony.luck@intel.com>
> Date:   Mon Mar 24 13:04:11 2008 -0700
> 
>     [IA64] Fix typo'd call to generic_smp_call_function_single_interrupt
>     
>     Should really be calling generic_smp_call_function_interrupt() for
>     the IPI_CALL_FUNC case.
>     
>     Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
> index fa26528..55cbc2c 100644
> --- a/arch/ia64/kernel/smp.c
> +++ b/arch/ia64/kernel/smp.c
> @@ -124,7 +124,7 @@ handle_IPI (int irq, void *dev_id)
>  
>  			switch (which) {
>  			      case IPI_CALL_FUNC:
> -				generic_smp_call_function_single_interrupt();
> +				generic_smp_call_function_interrupt();
>  				break;

Doh, that was a pretty silly typo. Thanks, I've merged it with the
patch!

So now I/we just need to figure out why the hack to call
init_call_single_data() is needed. You seem to imply it was being called
too late, I thought perhaps too early. Where did you stick the
init_call_single_data() call in?

-- 
Jens Axboe

