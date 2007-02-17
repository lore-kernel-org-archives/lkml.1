Return-Path: <linux-kernel-owner+w=401wt.eu-S1946345AbXBQAwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946345AbXBQAwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 19:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946352AbXBQAwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 19:52:09 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1034 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946345AbXBQAwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 19:52:08 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 16 Feb 2007 16:52:04 -0800 (PST)
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
Subject: Re: [patch 05/14] syslets: core code
In-Reply-To: <20070215165228.GF4285@elte.hu>
Message-ID: <Pine.LNX.4.64.0702161647090.14869@alien.or.mcafeemobile.com>
References: <20070215165228.GF4285@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Ingo Molnar wrote:

> +	spin_lock(&ah->lock);
> +
> +	new_async_thread = pick_ready_cachemiss_thread(ah);
> +	if (!new_async_thread)
> +		goto out_unlock;
> +
> +	async_ready = t->async_ready;
> +	WARN_ON(!async_ready);
> +	t->async_ready = NULL;
> +
> +	new_task = new_async_thread->task;
> +
> +	move_user_context(new_task, t);

Since I lost the email where you were describing the todo list, I'll hook 
into this one.
I haven't seen you mentioning it, but at least TID and signal handling 
need to be swapped to. So it'd be better to have a generic 
move_user_context() that does system independent work, and an 
arch_move_user_context() that takes care of system dependent stuff (that 
is called by move_user_context()).



- Davide


