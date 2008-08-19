Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYHSTZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYHSTZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYHSTZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:25:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbYHSTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:25:39 -0400
Date: Tue, 19 Aug 2008 15:22:16 -0400
From: Josef Bacik <jbacik@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
       rwheeler@redhat.com, tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] add hrtimer_sleep_ns helper function
Message-ID: <20080819192215.GB21749@unused.rdu.redhat.com>
References: <20080806190819.GH27394@unused.rdu.redhat.com> <20080819191508.GD8318@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819191508.GD8318@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 01:15:08PM -0600, Matthew Wilcox wrote:
> On Wed, Aug 06, 2008 at 03:08:19PM -0400, Josef Bacik wrote:
> > -static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
> > +static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode,
> > +				int interruptible)
> >  {
> >  	hrtimer_init_sleeper(t, current);
> >  
> >  	do {
> > -		set_current_state(TASK_INTERRUPTIBLE);
> > +		set_current_state(interruptible ? TASK_INTERRUPTIBLE :
> > +				  TASK_UNINTERRUPTIBLE);
> 
> I don't see any users (in this patch or the next) of people wanting
> uninterruptible nanosleeps.  We shouldn't be introducing new
> TASK_UNINTERRUPTIBLE users, but instead using TASK_KILLABLE if the user
> really can't cope with signals in a sensible manner.
>

Hmm doh, sorry about that the 2/2 patch of this series should be passing 0 not 1
since we need to be uninterruptible.  I figured this sort of thing would be used
by fs's/device drivers where TASK_UNINTERRUPTIBLE is desired.  If that is not
appropriate let me know and I can use TASK_KILLABLE or whatever else the
preference is.  Thanks,

Josef 
