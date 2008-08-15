Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYHOMFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYHOMFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYHOMEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:04:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYHOMEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:04:52 -0400
Date: Fri, 15 Aug 2008 14:04:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH](retry 4) invalidate caches before going into suspend
Message-ID: <20080815120434.GA17751@elte.hu>
References: <200808131141.18003.mark.langsdorf@amd.com> <20080813143206.07550498@infradead.org> <200808140845.05160.mark.langsdorf@amd.com> <200808140911.26617.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808140911.26617.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> When a CPU core is shut down, all of its caches need to be flushed to 
> prevent stale data from causing errors if the core is resumed. Current 
> Linux suspend code performs an assignment after the flush, which can 
> add dirty data back to the cache.  On some AMD platforms, additional 
> speculative reads have caused crashes on resume because of this dirty 
> data.
>  
> Relocate the cache flush to be the very last thing done before 
> halting.  Tie into an assembly line so the compile will not reorder 
> it.  Add some documentation explaining what is going on and why we're 
> doing this.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> Acked-by: Mark Borden <mark.borden@amd.com>
> Acked-by: Michael Hohmuth <michael.hohmuth@amd.com>

applied to tip/x86/urgent - thanks Mark.

	Ingo
