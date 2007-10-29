Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbXJ2F1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbXJ2F1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXJ2F1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:27:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41028 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXJ2F1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:27:06 -0400
Date: Mon, 29 Oct 2007 10:56:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kprobe_exceptions_notify(): fix NULL dereference
Message-ID: <20071029052635.GA8063@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20071027141914.GW30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027141914.GW30533@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 04:19:14PM +0200, Adrian Bunk wrote:
> This patch fixes later NULL dereferences spotted by the Coverity 
> checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

NACK... see below

> ---
> 
> BTW: The avr32 and s390 versions of kprobe_exceptions_notify() are
>      not touched since they don't contain this check.
> 
>  arch/ia64/kernel/kprobes.c    |    2 +-
>  arch/powerpc/kernel/kprobes.c |    2 +-
>  arch/sparc64/kernel/kprobes.c |    2 +-
>  arch/x86/kernel/kprobes_32.c  |    2 +-
>  arch/x86/kernel/kprobes_64.c  |    2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> b6f1241ee20dd22210f48b4100bc5055315f3808 
> diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
> index 5fd65d8..3663dfb 100644
> --- a/arch/ia64/kernel/kprobes.c
> +++ b/arch/ia64/kernel/kprobes.c
> @@ -886,11 +886,11 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
>  				       unsigned long val, void *data)
>  {
>  	struct die_args *args = (struct die_args *)data;
>  	int ret = NOTIFY_DONE;
> 
> -	if (args->regs && user_mode(args->regs))
> +	if (args->regs || user_mode(args->regs))

This change is incorrect as you return if args->regs != NULL leading to
a sure system crash.

Ananth
