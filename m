Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbXJAWh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbXJAWh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbXJAWhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:37:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46588 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbXJAWhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:37:19 -0400
Date: Mon, 1 Oct 2007 15:35:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: davids@webmaster.com
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20071001153529.7c669c7a@laptopd505.fenrus.org>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEPDHCAC.davids@webmaster.com>
References: <20071001125350.055ef9bb@laptopd505.fenrus.org>
	<MDEHLPKNGKAHNMBLJOLKGEPDHCAC.davids@webmaster.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 15:17:52 -0700
"David Schwartz" <davids@webmaster.com> wrote:

> 
> Arjan van de Ven wrote:
> 
> > > It can occasionally be an optimization. You may have a case where
> > > you can do something very efficiently if a lock is not held, but
> > > you cannot afford to wait for the lock to be released. So you
> > > check the lock, if it's held, you yield and then check again. If
> > > that fails, you do it the less optimal way (for example,
> > > dispatching it to a thread that *can* afford to wait).
> 
> > at this point it's "use a futex" instead; once you're doing system
> > calls you might as well use the right one for what you're trying to
> > achieve.
> 
> There are two answers to this. One is that you sometimes are writing
> POSIX code and Linux-specific optimizations don't change the fact
> that you still need a portable implementation.
> 
> The other answer is that futexes don't change anything in this case.
> In fact, in the last time I hit this, the lock was a futex on Linux.
> Nevertheless, that doesn't change the basic issue. The lock is
> locked, you cannot afford to wait for it, but not getting the lock is
> expensive. The solution is to yield and check the lock again. If it's
> still held, you dispatch to another thread, but many times, yielding
> can avoid that.

yielding IS blocking. Just with indeterminate fuzzyness added to it....
