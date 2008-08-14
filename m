Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbYHNOBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbYHNOBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYHNOAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:00:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:43487 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbYHNOAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:00:50 -0400
Date: Thu, 14 Aug 2008 07:00:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH](retry 3) invalidate caches before going into suspend
Message-ID: <20080814070055.0a47393d@infradead.org>
In-Reply-To: <200808140845.05160.mark.langsdorf@amd.com>
References: <200808131141.18003.mark.langsdorf@amd.com>
	<6453C3CB8E2B3646B0D020C112613273C5AC6B@sausexmb4.amd.com>
	<20080813143206.07550498@infradead.org>
	<200808140845.05160.mark.langsdorf@amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 08:45:04 -0500
Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> When a CPU core is shut down, all of its caches need to be flushed
> to prevent stale data from causing errors if the core is resumed.
> Current Linux suspend code performs an assignment after the flush,
> which can add dirty data back to the cache.  On some AMD platforms,
> additional speculative reads have caused crashes on resume because
> of this dirty data.
> 
> Relocate the cache flush to be the very last thing done before 
> halting.  Tie into an assembly line so the compile will not
> reorder it.  Add some documentation explaining what is going
> on and why we're doing this.


looks good to me

Acked-by: Arjan van de Ven <arjan@linux.intel.com>


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
