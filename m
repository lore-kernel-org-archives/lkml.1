Return-Path: <linux-kernel-owner+w=401wt.eu-S1759761AbZDWPUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761AbZDWPUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZDWPUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:20:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZDWPUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:20:19 -0400
Date: Thu, 23 Apr 2009 17:16:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jan Kratochvil <jan.kratochvil@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>
Subject: Q: ptrace_signal() && PTRACE_SETSIGINFO (Was: SIGSTOP && ptrace)
Message-ID: <20090423151633.GA3120@redhat.com>
References: <1158166a0904230515h333a78c9uf49931824c1dfe72@mail.gmail.com> <20090423142627.GA31572@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423142627.GA31572@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_signal:

	signr = current->exit_code;

	/* Update the siginfo structure if the signal has
	   changed.  If the debugger wanted something
	   specific in the siginfo structure then it should
	   have updated *info via PTRACE_SETSIGINFO.  */

Yes. PTRACE_SETSIGINFO can change *info if debugger wants something
special. But then we do:

	if (signr != info->si_signo) {
		info->si_signo = signr;
		info->si_errno = 0;
		info->si_code = SI_USER;
		info->si_pid = task_pid_vnr(current->parent);
		info->si_uid = task_uid(current->parent);
	}

Why? If the tracer changes ->exit_code it should know what it does.
Why do we reset *info?

But the real question, how can PTRACE_SETSIGINFO change ->si_signo
(for example, for do_signal_stop(si_signo)) if this in fact is not
allowed?

Oleg.

