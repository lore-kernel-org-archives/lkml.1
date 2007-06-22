Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbXFVMPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbXFVMPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXFVMPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:15:38 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:38335 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXFVMPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:15:37 -0400
Subject: Re: [RFC PATCH 4/6] Make DRM use the tasklet is-sched API
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <1182496085.3228.26.camel@dhcp193.mvista.com>
References: <20070622040014.234651401@goodmis.org>
	 <20070622040137.104281523@goodmis.org>
	 <1182494169.3228.11.camel@dhcp193.mvista.com>
	 <1182494960.20203.34.camel@chaos>
	 <1182496085.3228.26.camel@dhcp193.mvista.com>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 08:15:25 -0400
Message-Id: <1182514525.5493.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 00:08 -0700, Daniel Walker wrote:

> > > No sense in having a patch just for this, may as well merge this with
> > > patch 3 ..
> > 
> > Wrong. patch 3 adds the API and this one makes use of it. Stevens split
> > makes perfectly sense.
> 
> Clearly it doesn't make sense to me ;) .. The patches are too small to
> split them up that way ..

Daniel, you of all people should know. It's not the size of the patch
that matters, it's the way you use the patch ;-)


No these two patches should *not* be merged to one. If these are sitting
in -mm, and someone were to change the DRM to not to use the API and
someone else changed their driver to use the API, then what?  Does
Andrew keep these maintenance patches on top of each other?

The split lets the DRM patch be dropped or replaced while keeping the
API patch around in case another driver uses the API.

The two patches have two different objectives, even though they are
related and currently on a 1 to 1 basis. The patches regardless, should
stay separate.

-- Steve


