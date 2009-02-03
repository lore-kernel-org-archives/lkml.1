Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbZBCIPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbZBCIPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZBCIOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:14:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbZBCIOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:14:49 -0500
Date: Tue, 3 Feb 2009 00:14:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/6] epoll keyed wakeups v2 - introduce new *_poll()
 wakeup macros
Message-Id: <20090203001401.cc960d4e.akpm@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.13601.1233518664.2>
References: <send-serie.davidel@xmailserver.org.13601.1233518664.2>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Feb 2009 12:04:23 -0800 Davide Libenzi <davidel@xmailserver.org> wrote:

> +#define wake_up_nested_poll(x, m, s)					\
> +do {									\
> +	unsigned long flags;						\
> +									\
> +	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
> +	wake_up_locked_poll(x, m);					\
> +	spin_unlock_irqrestore(&(x)->lock, flags);			\
> +} while (0)

I had to go and find the callsite to work out the type of `x' :(

- this macro can be passed the address of any structure which has a
  `spinlock_t lock;' in it, which seems strange.

- It references its first arg three times.

Is there any reason why we can't implement this in C?  
