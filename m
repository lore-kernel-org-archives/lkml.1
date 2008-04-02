Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYDBNlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYDBNlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 09:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYDBNk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 09:40:57 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:36058 "EHLO smpt2.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755108AbYDBNk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:40:56 -0400
Date: Wed, 2 Apr 2008 15:16:25 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402131625.GI41073@gandalf.sssup.it>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, paulmck@linux.vnet.ibm.com,
	Ingo Molnar <mingo@elte.hu>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080402072846.GA16454@elte.hu> <20080402105539.GA5610@linux.vnet.ibm.com> <1207133961.8514.768.camel@twins> <20080402113327.GC41073@gandalf.sssup.it> <20080402114338.GA12774@kernel.dk> <20080402123620.GH12774@kernel.dk> <20080402123639.GI12774@kernel.dk> <20080402125530.GF41073@gandalf.sssup.it> <20080402125819.GO12774@kernel.dk> <20080402125857.GP12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402125857.GP12774@kernel.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, Apr 02, 2008 02:58:58PM +0200
>
> On Wed, Apr 02 2008, Jens Axboe wrote:
> > On Wed, Apr 02 2008, Fabio Checconi wrote:
> > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > Date: Wed, Apr 02, 2008 02:36:39PM +0200
> > > >
> > > > > Looks good and tests fine as well. I've applied it, on top of the
> > > > > hlist_for_each_entry_safe_rcu() fix.
> > > > > 
> > > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=436151ad32b4a59e0d36165a7d6312545f126661
> > > > > 
> > > 
> > > ok, thanks.  anyway I don't think the hlist_for_each_entry_safe_rcu()
> > > is needed at this point, since the pos->next pointer is still valid
> > > (at least) until the next rcu_read_unlock().  am I wrong?
> > 
> > it isn't, but it's still clearer. so either that or a nice comment, I
> > just stuck with what I had already committed.
> 

ok I agree on that.  the only remaining concern I have is that when
I first looked at it it seemed to me that hlist_for_each_entry_safe_rcu()
was missing by purpose from the list interface, since hlist_del_rcu()
can be called anyway during the traversal from a concurrent context,
so the semantics of *_safe_* have to be carried out by other means
(i.e., call_rcu()).

