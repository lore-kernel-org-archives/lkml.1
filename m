Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYHMSnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYHMSnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbYHMSmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:42:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:51166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654AbYHMSmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:42:31 -0400
Date: Wed, 13 Aug 2008 11:42:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH](retry 2) Re: invalidate caches before going into
 suspend
Message-ID: <20080813114229.118be446@infradead.org>
In-Reply-To: <200808131333.17850.mark.langsdorf@amd.com>
References: <200808131141.18003.mark.langsdorf@amd.com>
	<200808131230.07581.mark.langsdorf@amd.com>
	<20080813175232.GA1127@elte.hu>
	<200808131333.17850.mark.langsdorf@amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 13:33:17 -0500
Mark Langsdorf <mark.langsdorf@amd.com> wrote:
> +	/* mask all interrupts, flush any and all caches, and halt */
> +	if (cpu_has_clflush)
> +		wbinvd_halt();
> +	else
> +		while (1)
> +			halt();
>  }

I like the asm version .. but this code makes me blink.
when you HAVE clflush you do wbinvd.
yeah I know it's correct but... it reads wonky ;)
also.. can we move that check into the wbinvd_halt() itself, so that
the callers don't need to care what is used to select it ?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
