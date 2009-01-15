Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbZAOIrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbZAOIrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZAOIrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:47:19 -0500
Received: from genesysrack.ru ([195.178.208.66]:56737 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758411AbZAOIrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:47:18 -0500
Date: Thu, 15 Jan 2009 11:47:16 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dst@ioremap.net,
       Arjan van de Ven <arjan@infradead.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [4/7] dst: thread pool.
Message-ID: <20090115084716.GB29586@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <1231887933-17843-2-git-send-email-zbr@ioremap.net> <1231887933-17843-3-git-send-email-zbr@ioremap.net> <1231887933-17843-4-git-send-email-zbr@ioremap.net> <1231887933-17843-5-git-send-email-zbr@ioremap.net> <20090114215810.674569fc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114215810.674569fc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.

On Wed, Jan 14, 2009 at 09:58:10PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > Kernel currently does not allow to queue work into some entity which
> > will perform it in the process context and have simple way to extend
> > number of worker and work with them not as separate objects, but with
> > pool as a whole. So thread pool model was implemented in the DST.
> > 
> > Thread pool abstraction allows to schedule a work to be performed
> > on behalf of kernel thread. One does not operate with threads itself,
> > instead user provides setup and cleanup callbacks for thread pool itself,
> > and action and cleanup callbacks for each submitted work.
> > 
> > Each worker has private data initialized at creation time and data,
> > provided by user at scheduling time.
> > 
> > When action is being performed, thread can not be used by other users,
> > instead they will sleep until there is free thread to pick their work.
> > 
> > Thread pool is used for crypto processing of incoming and outgoing IO
> > requests to reduce the overall overhead.
> 
> This is at least our fourth thread pool implementation, not counting
> kernel/workqueue.c:
> 
> 1: pdflush

It is not really a pool of threads. But its works is somewhat similar.

> 2: David Howells' "slow work" infrastructure

I did not check it, it was not sent to fsdevel and only couple of
replies sneaked, according to them there are questionable cases (like
lots of global variables), but overall I can not say more.

> 3: Arjan van de Ven's kernel/async.c

Arjan does not answer to the mails. I sent him a review with
constructive critics, but it got lost in the void :)

> 4: Your "dst thread pool"

This one is rather simple case: set of thrads and blocking callbacks to
add the work.

-- 
	Evgeniy Polyakov
