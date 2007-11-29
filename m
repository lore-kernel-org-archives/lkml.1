Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXK2R37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXK2R37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbXK2R3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:29:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758777AbXK2R3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:29:51 -0500
Date: Thu, 29 Nov 2007 09:28:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 06/11] x86 ptrace arch merge
Message-Id: <20071129092852.3b7a4b2f.akpm@linux-foundation.org>
In-Reply-To: <20071129120014.E34C326F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
	<20071129120014.E34C326F8E7@magilla.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 04:00:14 -0800 (PST) Roland McGrath <roland@redhat.com> wrote:

> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -461,12 +461,13 @@ static int ptrace_set_debugreg(struct task_struct *child,
>  void ptrace_disable(struct task_struct *child)
>  {
>  	user_disable_single_step(child);
> +#ifdef TIF_SYSCALL_EMU
>  	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
> +#endif

Is TIF_SYSCALL_EMU ever undefined here?
