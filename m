Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbZANPCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbZANPCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760781AbZANPBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:01:47 -0500
Received: from cet.com.ru ([195.178.208.66]:44749 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760280AbZANPBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:01:46 -0500
Date: Wed, 14 Jan 2009 18:01:44 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [4/7] dst: thread pool.
Message-ID: <20090114150144.GA6419@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <1231887933-17843-2-git-send-email-zbr@ioremap.net> <1231887933-17843-3-git-send-email-zbr@ioremap.net> <1231887933-17843-4-git-send-email-zbr@ioremap.net> <1231887933-17843-5-git-send-email-zbr@ioremap.net> <20090114144602.GG10720@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114144602.GG10720@gambetta>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederik.

Thanks for the comment!

On Wed, Jan 14, 2009 at 03:46:02PM +0100, Frederik Deweerdt (frederik.deweerdt@xprog.eu) wrote:
> On Wed, Jan 14, 2009 at 02:05:30AM +0300, Evgeniy Polyakov wrote:
> [...]
> > +void thread_pool_del_worker(struct thread_pool *p)
> > +{
> > +	struct thread_pool_worker *w = NULL;
> > +
> > +	while (!w) {
> > +		wait_event(p->wait, !list_empty(&p->ready_list) || !p->thread_num);
> 								   ^^^^^^^^^^^^^^
> What's the purpose of !p->thread_num here? Is there an exit case missing
> in the loop below?

It is needed if thread was not in the ready_list but existed because of
some global flag. Current code does not use simultaneous exit and this
function is entered only when there are threads in the pool, so it
should be correct. But if called by several threads, it should be an
exit condition. I will put it into the loop termination check for the
completeness.

-- 
	Evgeniy Polyakov
