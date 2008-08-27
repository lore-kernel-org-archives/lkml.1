Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYH0QUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYH0QUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYH0QUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:20:38 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58426 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbYH0QUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:20:38 -0400
Date: Wed, 27 Aug 2008 20:24:55 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pierre Morel <pmorel@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC] [Patch 1/1] [Self Ptrace] System call notification with self_ptrace
Message-ID: <20080827162455.GA132@tv-sign.ru>
References: <48B26083.8080506@linux.vnet.ibm.com> <20080825165403.GA604@tv-sign.ru> <48B40D5F.3020705@linux.vnet.ibm.com> <20080826162750.GA406@tv-sign.ru> <48B5658A.5000101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B5658A.5000101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Pierre Morel wrote:
>
> Oleg Nesterov wrote:
>
> >On s390 the patch changes handle_signal(), this is not clear to me too.
> >
> The patch clears the trace flags before delivering the signal so
> that the signal handler can use system call without bouncing again.

Yes I see. But the signal handler for SIGSYS can fisrt do
sys_ptrace(PTRACE_SELF_OFF) (which is filtered out), and then use any
other syscall.

With this patch PT_SELF is cleared on any signal. This doesn't look
right. Let's suppose that another signal comes in parallel with SIGSYS.
It is very possible that the handler for that another signal will be
called first, this handler can do some syscall which will be "missed".

> >Isn't it possible to implement this behaviour in the user space? If the
> >task needs the PT_SELF behaviour, it can fork another process which will
> >do PTRACE_ATTACH and then send the notifications to the task. We can use
> >signals or something else.
> >
> In this case we would go back to standard ptrace behaviour.
> The goal of the patch is to avoid the overhead of task switching
> and IPC when instrumenting the process.

Ah, I forgot to read the changelog, sorry.

Oleg.

