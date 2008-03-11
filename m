Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbYCKSSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbYCKSSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYCKSRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:17:53 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34455 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbYCKSRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:17:52 -0400
Date: Tue, 11 Mar 2008 21:22:13 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] signals: print_fatal_signal: fix the signr "calculation"
Message-ID: <20080311182213.GD586@tv-sign.ru>
References: <20080308172453.GA28323@tv-sign.ru> <20080308190311.779B326F990@magilla.localdomain> <20080309110511.GA18128@elte.hu> <20080309161153.GA76@tv-sign.ru> <20080311021928.B725E26F991@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311021928.B725E26F991@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Roland McGrath wrote:
>
> > For various reasons we can't currently do the same for sig_kernel_coredump()
> > signals. But, when rlim[RLIMIT_CORE] == 0, we don't actually need coredumping?
> > So, we could do something like
> > 
> > 
> > 	-	if (!sig_kernel_coredump(sig)) {
> > 	+	if (!sig_kernel_coredump(sig) || !signal->rlim[RLIMIT_CORE]) {
> 
> I don't like this.  I think it's better to leave logic like RLIMIT_CORE
> checks to the core dump code itself.

As I said, this was just for illustration.

What I am thinking about is how to restore the "sig_kernel_coredump() signal
freezes the whole group on delivery" behaviour, we had this before
198466b41d11dd062fb26ee0376080458d7bfcaf.

Afaics this is possible, we could add another SIGNAL_XXX flag but send SIGKILL,
this also unifies the fatal signals processing.

Oleg.

