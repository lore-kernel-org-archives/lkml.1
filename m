Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbXFVPks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbXFVPks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbXFVPkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:40:39 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23657 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbXFVPki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:40:38 -0400
Subject: Re: [RFC PATCH 4/6] Make DRM use the tasklet is-sched API
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <1182514525.5493.4.camel@localhost.localdomain>
References: <20070622040014.234651401@goodmis.org>
	 <20070622040137.104281523@goodmis.org>
	 <1182494169.3228.11.camel@dhcp193.mvista.com>
	 <1182494960.20203.34.camel@chaos>
	 <1182496085.3228.26.camel@dhcp193.mvista.com>
	 <1182514525.5493.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 08:36:42 -0700
Message-Id: <1182526602.3228.43.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 08:15 -0400, Steven Rostedt wrote:
> On Fri, 2007-06-22 at 00:08 -0700, Daniel Walker wrote:
> 
> > > > No sense in having a patch just for this, may as well merge this with
> > > > patch 3 ..
> > > 
> > > Wrong. patch 3 adds the API and this one makes use of it. Stevens split
> > > makes perfectly sense.
> > 
> > Clearly it doesn't make sense to me ;) .. The patches are too small to
> > split them up that way ..
> 
> Daniel, you of all people should know. It's not the size of the patch
> that matters, it's the way you use the patch ;-)
> 

Are you trying to say that you think I have a small patch Steven ;) ?

> No these two patches should *not* be merged to one. If these are sitting
> in -mm, and someone were to change the DRM to not to use the API and
> someone else changed their driver to use the API, then what?  Does
> Andrew keep these maintenance patches on top of each other?

I read this 5 times at least .. I don't think I'm following what you
saying .. It sounds like you might be thinking to many steps ahead tho..

> The split lets the DRM patch be dropped or replaced while keeping the
> API patch around in case another driver uses the API.

Ok, but there are no other users currently, and I think it's unlikely
you'll have others in the future since TASKLET_STATE_SCHED seems more
like an internal part of tasklets .. This drm user seems like the one
aberrant.

> The two patches have two different objectives, even though they are
> related and currently on a 1 to 1 basis. The patches regardless, should
> stay separate.

I'm not convinced yet .. One more stab?

Daniel

