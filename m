Return-Path: <linux-kernel-owner+w=401wt.eu-S1030708AbXBOTPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030708AbXBOTPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030711AbXBOTPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:15:00 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1065 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030708AbXBOTO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:14:59 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 15 Feb 2007 11:14:58 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 08/14] syslets: x86, add create_async_thread() method
In-Reply-To: <20070215165239.GI4285@elte.hu>
Message-ID: <Pine.LNX.4.64.0702151111250.11064@alien.or.mcafeemobile.com>
References: <20070215165239.GI4285@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Ingo Molnar wrote:

> +ENTRY(async_thread_helper)
> +	CFI_STARTPROC
> +	/*
> +	 * Allocate space on the stack for pt-regs.
> +	 * sizeof(struct pt_regs) == 64, and we've got 8 bytes on the
> +	 * kernel stack already:
> +	 */
> +	subl $64-8, %esp
> +	CFI_ADJUST_CFA_OFFSET 64

Maybe a comment here would help in explaining why we do need space for the 
extra pt_regs (on top of the one already allocated in do_fork()) ;)
It's not immediately clear that ret_from_fork and syscall_exit will issue 
two nested RESTORE_REGS.



- Davide


