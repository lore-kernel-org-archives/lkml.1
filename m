Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYLDP1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYLDP1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYLDP1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:27:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49006 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYLDP1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:27:45 -0500
Date: Thu, 4 Dec 2008 16:26:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rnalumasu@gmail.com
Subject: Re: + do_wait-wakeup-optimization.patch added to -mm tree
Message-ID: <20081204152601.GB8816@redhat.com>
References: <200811212015.mALKFMs4019558@imap1.linux-foundation.org> <20081123213929.GA9097@redhat.com> <20081204005203.C795EFC3AB@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204005203.C795EFC3AB@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Roland McGrath wrote:
>
> > > +static int do_wait_wake_function(wait_queue_t *curr, unsigned mode, int sync,
> > > +				 void *key)
> > > +{
> > > +	struct task_struct *task = current;
> >
> > I think we can fix (and simplify) this code if we change __wake_up_parent(),
> > it should call __wake_up(key => p), so we can do
> >
> > 	struct task_struct *task = key;
>
> I don't see an exposed __wake_up* variant that both passes a "key" pointer
> through and does "sync".  For __wake_up_parent, "sync" is quite desireable.

Well, yes... and __wake_up_common() is static. Perhaps we can make a new
helper. I must admit, I don't understand what "sync" actually means nowadays.

> > > +	if (!needs_wakeup(task, w))
> > > +		return 0;
> > > +
> > > +	return default_wake_function(curr, mode, sync, key);
> >
> > perhaps autoremove_wake_function() makes more sense.
>
> Why?  The do_wait loop will have to go through again and still might just
> sleep again.  The explicit remove at the end of do_wait seems fine to me.

Yes, yes, I was wrong. I forgot about "repeat:" in do_wait().

Oleg.

