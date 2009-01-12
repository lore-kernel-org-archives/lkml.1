Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZALRWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZALRWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZALRWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:22:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:55698 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZALRWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:22:04 -0500
Subject: Re: [PATCH 22/24] i386: add TRACE_IRQS_OFF for the nmi
From: Peter Zijlstra <peterz@infradead.org>
To: heukelum@fastmail.fm
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <1220990178-29773-23-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-5-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-6-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-7-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-8-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-9-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-10-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-11-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-12-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-13-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-14-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-15-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-16-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-17-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-18-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-19-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-20-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-21-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-22-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-23-git-send-email-heukelum@fastmail.fm>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 18:21:51 +0100
Message-Id: <1231780911.4371.196.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 21:56 +0200, heukelum@fastmail.fm wrote:
> From: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> At this point interrupts are off, so let's inform the tracing
> code of that fact before calling into C.

Sorry but this is an obvious dud, lockdep (and thus the irq state
tracer) aren't nmi safe.

Ingo, please revert, as people are already seeing lockdep warnings due
to this.

> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> ---
>  arch/x86/kernel/entry_32.S |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index a278505..2abdc9a 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -849,6 +849,7 @@ nmi_stack_correct:
>  	pushl %eax
>  	CFI_ADJUST_CFA_OFFSET 4
>  	SAVE_ALL
> +	TRACE_IRQS_OFF
>  	xorl %edx,%edx		# zero error code
>  	movl %esp,%eax		# pt_regs pointer
>  	call do_nmi
> @@ -889,6 +890,7 @@ nmi_espfix_stack:
>  	pushl %eax
>  	CFI_ADJUST_CFA_OFFSET 4
>  	SAVE_ALL
> +	TRACE_IRQS_OFF
>  	FIXUP_ESPFIX_STACK		# %eax == %esp
>  	xorl %edx,%edx			# zero error code
>  	call do_nmi

