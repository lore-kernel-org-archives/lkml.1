Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZKPPJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZKPPJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZKPPJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:09:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48340 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZKPPJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:09:53 -0500
Date: Mon, 16 Nov 2009 16:09:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86: Add missing might_fault() from copy_{to,from}_user()
Message-ID: <20091116150937.GA22187@elte.hu>
References: <1258382538-30979-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258382538-30979-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> In x86-64, copy_to/from_user() rely on assembly routines that never
> call might_fault(), making us missing various lockdep checks.
> 
> This doesn't apply to __copy_from,to_user() that explicitly handle
> these calls, neither is it a problem in x86-32 where
> copy_to,from_user() rely on the "__" prefixed versions that also call
> might_fault().
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/include/asm/uaccess_64.h |   10 +++++++++-
>  arch/x86/lib/copy_user_64.S       |    4 ++--
>  2 files changed, 11 insertions(+), 3 deletions(-)

Looks good - other than that you missed the renaming of the symbol 
export line in arch/x86/kernel/x8664_ksyms_64.c, which i fixed.

Thanks,

	Ingo
