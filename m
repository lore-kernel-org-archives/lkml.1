Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZGHMMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZGHMMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZGHMMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:12:34 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:61317 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbZGHMMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:12:34 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
 cond_resched*()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: avorontsov@ru.mvista.com
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090708120302.GA6341@oksana.dev.rtsoft.ru>
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
	 <20090708005000.GA12380@redhat.com> <1247034263.9777.24.camel@twins>
	 <20090708120302.GA6341@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 14:12:25 +0200
Message-Id: <1247055145.9777.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 16:03 +0400, Anton Vorontsov wrote:
> On Wed, Jul 08, 2009 at 08:24:23AM +0200, Peter Zijlstra wrote:
> > On Wed, 2009-07-08 at 02:50 +0200, Oleg Nesterov wrote:
> > 
> > > 	/*
> > > 	 * It is valid to assume CPU-locality during early bootup:
> > > 	 */
> > > 	if (system_state != SYSTEM_RUNNING)
> > > 		goto out;
> > > 
> > > this doesn't look right, smp_init() is called before we set
> > > SYSTEM_RUNNING.
> > 
> > The thing is, there's also ton's of code that might end up calling
> > cond_resched() and co before the scheduler is fully initialized.
> 
> Hm. Speaking of cond_resched*() only, then it should be pretty
> safe to convert the SYSTEM_RUNNING checks to scheduler_running,
> no? scheduler_running is set after sched_init().

Hmm, that might work, I'd have to audit sched_init_smp() as it seems to
do way too much...


