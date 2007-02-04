Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXBDFMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXBDFMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 00:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXBDFMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 00:12:35 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3200 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbXBDFMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 00:12:35 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 3 Feb 2007 21:12:27 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Zach Brown <zach.brown@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
Message-ID: <Pine.LNX.4.64.0702032112220.16929@alien.or.mcafeemobile.com>
References: <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Zach Brown wrote:

> +	/* 
> +	 * XXX The idea is to copy all but the actual call stack.  Obviously
> +	 * this is wildly arch-specific and belongs abstracted out.
> +	 */
> +	*next->ti = *ti;
> +	*thread_info_pt_regs(next->ti) = *thread_info_pt_regs(ti);

arch copy_thread_info()?



> +	current->per_call = next->per_call;

Pointer instead of structure copy? percall_clone()/percall_free()?



> +	/* always switch to a runnable fibril if we aren't being preempted */
> +	if (unlikely(!(preempt_count() & PREEMPT_ACTIVE) &&
> +		     !list_empty(&prev->runnable_fibrils))) {
> +		schedule_fibril(prev);
> +		/* 
> +		 * finish_fibril_switch() drops the rq lock and enables
> +		 * premption, but the popfl disables interrupts again.  Watch
> +		 * me learn how context switch locking works before your very
> +		 * eyes!  XXX This will need to be fixed up by throwing
> +		 * together something like the prepare_lock_switch() path the
> +		 * scheduler does.  Guidance appreciated!
> +		 */
> +		local_irq_enable();
> +		return;
> +	}

Yes, please (prepare/finish) ... ;)



- Davide


