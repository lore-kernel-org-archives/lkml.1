Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYJGRgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYJGRgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYJGRgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:36:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38934 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbYJGRgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:36:46 -0400
Subject: RE: [malware-list] [RFC] 0/11 fanotify: fscking all notifiction
	andfile access	system (intended for antivirus scanning and fileindexers)
From: Eric Paris <eparis@redhat.com>
To: "Michael Morley, HCL America" <mmorley@hcl.in>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <5CB739747AC639489F3E8210950C3E555C39EE@geousmail3.GEO.CORP.HCL.IN>
References: <1222463220.2872.193.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0809262259290.4229@asgard.lang.hm>
	 <1222524294.2872.252.camel@localhost.localdomain>
	 <5CB739747AC639489F3E8210950C3E555C39EE@geousmail3.GEO.CORP.HCL.IN>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 13:36:30 -0400
Message-Id: <1223400990.2994.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 10:32 -0700, Michael Morley, HCL America wrote:
> > 
> > On Fri, 2008-09-26 at 23:05 -0700, david@lang.hm wrote:
> > > On Fri, 26 Sep 2008, Eric Paris wrote:
> > >
> > > > fanotify has 7 event types and only sends events for S_ISREG()
> files.
> > > > The event types are OPEN, READ, WRITE, CLOSE_WRITE, CLOSE_NOWRITE,
> > > > OPEN_ACCESS, and READ_ACCESS.  Events OPEN_ACCESS and READ_ACCESS
> > > > require that the listener return some sort of allow/deny/more_time
> > > > response as the original process blocks until it gets an event (or
> > times
> > > > out.)  listeners may register a group which will get notifications
> > about
> > > > any combination of these events.  Antivirus scanners will likely
> want
> > > > OPEN_ACCESS and READ_ACCESS while file indexers would likely use
> the
> > > > non-ACCESS form of these events.
> > >
> > > sending a message out for every READ/WRITE seems like it will
> generate a
> > > LOT of messages, and very few will be ones that anyone cares about.
> > >
> > > one of the nice things about the TALPA approach was that there was
> an
> > > ability to notify only on a change of state (i.e. when a file that
> had
> > > been scanned was changed)
> > >
> > > this could do a similar thing, but I think it would be a much more
> > > expensive process to do it all in userspace.
> > 
> > See the fastpath patch and explaination.  Doesn't help for writes...
> > 
> 
> Eric, have you considered the scenario where the listening process
> appears to have stopped responding to access events? Under your design,
> the original process would be released after 5 seconds. Too many of
> these timeouts could wreak havoc on the OS. There should be some logic
> in fanotify to remove the fanotify_group after a certain number of
> timeouts which may or may not have to be sequential.

anyone have thoughts on the topic?  Maybe I'll revisit it after I get a
new user interface.  25 missed permission events and I can just evict a
group altogether.  Should the counter be cleared if a listener makes a
decision?

> Less importantly, it would be nice if the listening process could set
> the timeout value when it registers with fanotify (with some limits of
> course).

noted.

