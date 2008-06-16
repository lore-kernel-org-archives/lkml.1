Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYFPOSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYFPOSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYFPOSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:18:31 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38096 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbYFPOSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:18:30 -0400
Date: Mon, 16 Jun 2008 18:20:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] resend, ptrace && SIGKILL fixes
Message-ID: <20080616142016.GA13339@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10, Oleg Nesterov wrote:
>
> These 2 patches don't depend on each other. Each change is user visible,
> and I am not really sure it can't confuse debuggers/etc. The explicit
> ack/nack from maintainers is wanted.

I'm mostly worried about do_exit()->ptrace_notify(), with these patches
we never notify the tracer if the tracee was SIGKILL'ed. The current
behaviour depends on arch_ptrace_stop_needed(), this is not good either.

Anyway, I think these patches are fixes. Suppose we send SIGKILL to the
traced task which does ptrace_notify(). If the signal is delivered before
ptrace_notify() takes ->siglock, the tracee sleeps in TASK_TRACED state
and becomes "unkillable". If ptrace_notify() wins, we kill the tracee.
This can't be good.

The 3rd patch is new.

Oleg.

