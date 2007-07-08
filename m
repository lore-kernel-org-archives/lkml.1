Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbXGHSMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbXGHSMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbXGHSLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:11:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbXGHSLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:11:48 -0400
To: avi@qumranet.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com>
From: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <11838994974161-git-send-email-avi@qumranet.com>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
Date: 08 Jul 2007 21:07:10 +0200
Message-ID: <p73ir8uzpcx.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi-atKUWr5tajBWk0Htik3J/w@public.gmane.org> writes:
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 693f0e6..b705876 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -875,6 +875,10 @@ struct task_struct {
>  	pid_t pid;
>  	pid_t tgid;
>  
> +#ifdef CONFIG_SCHED_KVM
> +	struct kvm_vcpu *kvm_vcpu;
> +#endif

You should be careful to put this into a cache line that 
is already touched during context switch. Otherwise
if it needs an additional cache miss it might become
very costly

Also it's a bit worrying to expose hooks into the scheduler
to any modules. How would others be stopped from abusing this?

-Andi
