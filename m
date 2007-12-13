Return-Path: <linux-kernel-owner+w=401wt.eu-S1765381AbXLMRjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765381AbXLMRjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762720AbXLMRjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:39:07 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:50103 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763712AbXLMRjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:39:06 -0500
Date: Thu, 13 Dec 2007 20:39:56 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>,
       Tony Luck <tony.luck@intel.com>, Matthew Wilcox <willy@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_ptrace_stop
Message-ID: <20071213173956.GA436@tv-sign.ru>
References: <20071213172926.GA423@tv-sign.ru> <20071213173136.GO26334@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213173136.GO26334@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Matthew Wilcox wrote:
>
> On Thu, Dec 13, 2007 at 08:29:26PM +0300, Oleg Nesterov wrote:
> > How is it possible that SIGKILL is blocked?
> 
> I *think* it's possible that kernel threads may block SIGKILL.
> And I think init (pid 1) gets SIGKILL blocked.

Yes. But this shouldn't matter because we can't ptrace them. /sbin/init
doesn't block SIGKILL, but it can't be ptraced either.

Also, SIGKILL is blocked only if kthread was created by kernel_thread() and
then it does daemonize(). kthread_create()'ed kthreads don't block SIGKILL
but ignore it. The latter behaviour is more correct, but we can't do the same
for kernel_thread() threads.

Oleg.

