Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0BOTkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:40:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab0BOTkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:40:35 -0500
Date: Mon, 15 Feb 2010 20:39:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracehook: add some self tests
Message-ID: <20100215193948.GA28419@redhat.com>
References: <1266214553-29476-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266214553-29476-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Mike Frysinger wrote:
>
> +static int __init syscall_test(void)
> +{
> +	struct pt_regs _regs, *regs = &_regs;
> +	long _args[8];
> +	long *args = _args + 1;
> +	long *sys_args[6], *sa;
> +	unsigned int i, n, s;
> +
> +	/*
> +	 * First find each system register in pt_regs.  We have to assume
> +	 * syscall_set_arguments() works with very basic arguments.
> +	 */
> +	pr_info("TEST: asm/syscall.h: arg offsets: { ");
> +
> +	for (s = 0; s < 6; ++s)
> +		args[s] = s;
> +	memset(regs, 0xad, sizeof(*regs));
> +	syscall_set_arguments(NULL, regs, 0, 6, args);
                              ^^^^

I am not sure ia64 can tolerate task == NULL. Hmm, even x86 checks
task_thread_info(task)->status.

Probably CONFIG_TRACEHOOK_SELF_TEST needs more attention ?

Otherwise, I convinced myself I understand what this code does, and
it looks good ;)

Oleg.

