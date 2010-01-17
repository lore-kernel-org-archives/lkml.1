Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393Ab0AQDoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab0AQDoO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 22:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199Ab0AQDoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 22:44:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:36488 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0AQDoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 22:44:10 -0500
Date: Sat, 16 Jan 2010 19:44:04 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Matthew Helsley <matt.helsley@gmail.com>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, containers@lists.linux-foundation.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] fanotify: Add pids to events
Message-ID: <20100117034403.GB3714@count0.beaverton.ibm.com>
References: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
 <201001151612.10032.agruen@suse.de>
 <20100115212146.GA3714@count0.beaverton.ibm.com>
 <201001162353.45800.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001162353.45800.agruen@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 11:53:45PM +0100, Andreas Gruenbacher wrote:
> On Friday 15 January 2010 10:21:46 pm Matt Helsley wrote:
> > On Fri, Jan 15, 2010 at 04:12:09PM +0100, Andreas Gruenbacher wrote:
> > > > 2. If the event recipient does a clone and enters a new pidns the pid
> > > > number will be incorrect without any indication.
> > >
> > > No, if a process has a pid within the listener's namespace the listener
> > > will see this pid; otherwise, the resulting pid value is 0.
> > 
> > So the pid reference is resolved at read(), correct? If so then that's
> >  fine. (Otherwise I'd think the values could still become stale).
> 
> Yes.  Note that for non-blocking events, there is no guarantee that the 
> triggering process still runs when the event is consumed though.

Holding the reference until the event is read ensures the pid
won't be reused in that namespace, so I think that's fine.

Cheers,
	-Matt Helsley
