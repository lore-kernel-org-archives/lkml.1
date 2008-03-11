Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYCKCTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYCKCTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYCKCTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:19:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbYCKCTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:19:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] signals: print_fatal_signal: fix the signr "calculation"
In-Reply-To: Oleg Nesterov's message of  Sunday, 9 March 2008 19:11:53 +0300 <20080309161153.GA76@tv-sign.ru>
References: <20080308172453.GA28323@tv-sign.ru>
	<20080308190311.779B326F990@magilla.localdomain>
	<20080309110511.GA18128@elte.hu>
	<20080309161153.GA76@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080311021928.B725E26F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 19:19:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For various reasons we can't currently do the same for sig_kernel_coredump()
> signals. But, when rlim[RLIMIT_CORE] == 0, we don't actually need coredumping?
> So, we could do something like
> 
> 
> 	-	if (!sig_kernel_coredump(sig)) {
> 	+	if (!sig_kernel_coredump(sig) || !signal->rlim[RLIMIT_CORE]) {

I don't like this.  I think it's better to leave logic like RLIMIT_CORE
checks to the core dump code itself.


Thanks,
Roland
