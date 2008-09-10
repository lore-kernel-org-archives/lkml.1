Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYIJQWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYIJQWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYIJQWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:22:00 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57763 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYIJQV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:21:59 -0400
Subject: Re: [PATCH 1/1] system call notification with self_ptrace
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Pierre Morel <pmorel@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, gregkh@suse.de,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Cedric Le Goater <clg@fr.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
In-Reply-To: <48C51439.7000706@linux.vnet.ibm.com>
References: <48C51439.7000706@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 09:19:34 -0700
Message-Id: <1221063574.6781.8.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 14:02 +0200, Pierre Morel wrote:
> 
> +       if (is_self_ptracing(regs->gprs[2])) {
> +               if (!entryexit) {
> +                       struct siginfo info;
> +
> +                       memset(&info, 0, sizeof(struct siginfo));
> +                       info.si_signo = SIGSYS;
> +                       info.si_code = SYS_SYSCALL;
> +                       info.si_errno = regs->gprs[2];
> +                       info.si_addr = (void *)regs->orig_gpr2;
> +                       send_sig_info(SIGSYS, &info, current);
> +                       regs->gprs[2] = -1;
> +               }
> +               return;
> +       }

I see you didn't like my suggestions for consolidating some of these
repetitive code bits across all the architectures.  Did you give that a
a shot?  Would you like me to produce a patch on top of what you have
here before this gets merged into mm?

-- Dave

