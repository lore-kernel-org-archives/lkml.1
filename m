Return-Path: <linux-kernel-owner+w=401wt.eu-S966519AbXIBM7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966519AbXIBM7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965317AbXIBM7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:59:15 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60892 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965449AbXIBM7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:59:14 -0400
Date: Sun, 2 Sep 2007 17:02:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: [RFC + PATCH] signalfd simplification
Message-ID: <20070902130234.GA183@tv-sign.ru>
References: <Pine.LNX.4.64.0709011618280.4045@alien.or.mcafeemobile.com> <20070902121943.GA141@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902121943.GA141@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Oleg Nesterov wrote:
>
> Small problem: unless I missed something, signalfd_deliver() and sys_signalfd()
> should use wake_up_all(), not wake_up() which implies nr_exclusive == 1.
> 
> It is possible that we have multiple threads waiting on ->signalfd_wqh with
> the the different ->sigmask. In this case, the first woken thread can ignore
> the signal, we should wake up all of them.

Oops, sorry for noise. I forgot about WQ_FLAG_EXCLUSIVE, we don't set it by
default.

Oleg.

