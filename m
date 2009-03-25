Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZCYWy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZCYWy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZCYWyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:54:18 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:41390 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZCYWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:54:17 -0400
Date: Wed, 25 Mar 2009 16:54:14 -0600
From: Alex Chiang <achiang@hp.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: htejun@gmail.com, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
Message-ID: <20090325225414.GA11447@ldl.fc.hp.com>
References: <20090325035707.15921.42150.stgit@bob.kio> <m13ad2xi46.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13ad2xi46.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric W. Biederman <ebiederm@xmission.com>:
> 
> Interesting.
> 
> Fixing a read/writer deadlock by allowing the writers to nest
> inside the readers.
> 
> My first impression is that it is too clever.

Clever points go to Tejun. All I did was refresh the series
slightly. :)

> Furthermore I think this is walking around the edges of a more
> general problem.   How should we serial hotplug and hotunplug
> in general.  In what context should remove methods run in.
> 
> My impression is that we have a huge hole in our infrastructure
> for hotplug drivers.  Problems like how do we get a user space
> context for the code to run in and how do we handle
> multiple hotplug actions for overlapping device trees from
> stomping on each other.
> 
> My hypothesis is once we solve this for the general case of
> device hotplug and removal we won't need special support from
> sysfs.  At least not in the suicidal way.

I agree that we have problems in our infrastructure, especially,
as you point out, overlapping device trees, etc.

I see your point about adding extra cruft into sysfs to work
around a special case while leaving the hard problem unsolved.

Perhaps the status quo is better. I do think that getting
suicidal sysfs attributes off the global workqueue is a band-aid
that actually helps, vs. the proposed patches here which are
questionable in nature.

Oh well.

Thanks for the comments.

/ac

> 
> We still have very weird cases such as the lock inversion that
> we have today between rtnl_lock and active reference count,
> coming from the networking code.
> 
> Eric
> 
