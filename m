Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbXJATzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbXJATzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbXJATzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:55:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51849 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbXJATzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:55:44 -0400
Date: Mon, 1 Oct 2007 12:53:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: davids@webmaster.com
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20071001125350.055ef9bb@laptopd505.fenrus.org>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGENHHCAC.davids@webmaster.com>
References: <20071001162507.GA22791@elte.hu>
	<MDEHLPKNGKAHNMBLJOLKGENHHCAC.davids@webmaster.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 09:49:35 -0700
"David Schwartz" <davids@webmaster.com> wrote:

> 
> > * Jarek Poplawski <jarkao2@o2.pl> wrote:
> >
> > > BTW, it looks like risky to criticise sched_yield too much: some
> > > people can misinterpret such discussions and stop using this at
> > > all, even where it's right.
> 
> > Really, i have never seen a _single_ mainstream app where the use of
> > sched_yield() was the right choice.
> 
> It can occasionally be an optimization. You may have a case where you
> can do something very efficiently if a lock is not held, but you
> cannot afford to wait for the lock to be released. So you check the
> lock, if it's held, you yield and then check again. If that fails,
> you do it the less optimal way (for example, dispatching it to a
> thread that *can* afford to wait).


at this point it's "use a futex" instead; once you're doing system
calls you might as well use the right one for what you're trying to
achieve.
