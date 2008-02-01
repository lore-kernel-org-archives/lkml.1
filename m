Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbYBAKyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbYBAKyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYBAKyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:54:45 -0500
Received: from ns.suse.de ([195.135.220.2]:47096 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbYBAKyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:54:44 -0500
Subject: Re: [bug] as_merged_requests(): possible recursive locking detected
From: Nikanth Karthikesan <knikanth@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080201101212.GK15220@kernel.dk>
References: <20080131221436.GA3760@elte.hu>
	 <1201860191.10128.0.camel@nikanth-laptop.blr.novell.com>
	 <20080201101212.GK15220@kernel.dk>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 16:30:02 +0530
Message-Id: <1201863602.12205.4.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-01 at 11:12 +0100, Jens Axboe wrote: 
> On Fri, Feb 01 2008, Nikanth Karthikesan wrote:
> > On Thu, 2008-01-31 at 23:14 +0100, Ingo Molnar wrote:
> > > 
> > > Jens,
> > > 
> > > AS still has some locking issues - see the lockdep warning below that 
> > > the x86 test-rig just triggered. Config attached. Never saw this one 
> > > before. Can send more info if needed.
> > > 
> > 
> > The io_contexts are swapped. And while swapping, the locks were also
> > getting swapped, which will change the order of locking after that. This
> > may be the cause of these warning. I am not sure whether not swapping
> > the locks is the right way to fix this. Using a field of spinlock_t
> > itself to order locking might be better, instead of the address of the
> > container.
> > 
> > Now while adding a new member to io_context, one should not forget to
> > add it here. Also copying whole io_context and then restoring the locks
> > might have a window where this warning could be triggered.
> 
> Oops, the locks should definitely be left alone. It's not just the
> locking order, but also it would confuse lockdep.

Oops..  It may not need any locking at all! It seems that we just swap
the pointers and do not copy the struct at all! Sorry for confusing with
my patch. I am also confused, as the swap itself seems to do nothing! 

Thanks
Nikanth Karthikesan

