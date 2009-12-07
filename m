Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZLGI5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZLGI5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934821AbZLGI5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:57:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934778AbZLGI5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:57:08 -0500
Subject: Re: [PATCH 7/7] sched: implement try_to_wake_up_local()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <1260175804.8223.1217.camel@laptop>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-8-git-send-email-tj@kernel.org>
	 <1259923487.3977.1940.camel@laptop>  <4B1C75F3.9080808@kernel.org>
	 <1260175804.8223.1217.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 09:56:39 +0100
Message-ID: <1260176199.8223.1237.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 09:50 +0100, Peter Zijlstra wrote:
> On Mon, 2009-12-07 at 12:26 +0900, Tejun Heo wrote:

> > Hmmm... it was intentional as, before this patch, there's no
> > try_to_wake_up_local() so it was strange to mention it in the comment.
> > I can move the comments but I don't think it's particularly better
> > that way.
> 
> /me reads the comments and goes ah!
> 
> OK, maybe you've got a point there ;-)


OK, so you fork and wakeup a new thread when an existing one goes to
sleep, but do you also limit the concurrency on wakeup?

Otherwise we can end up with say 100 workqueue tasks running, simply
because they all ran into a contended lock and then woke up again.

Where does that fork happen? Having to do memory allocations and all
that while holding the rq->lock doesn't seem like a very good idea.

What happens when you run out of memory and the workqueue progress is
needed to get free memory?

