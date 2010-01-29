Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840Ab0A2ULL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0A2ULL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793Ab0A2ULJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:11:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:44318 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab0A2ULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:11:08 -0500
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Cong Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
In-Reply-To: <20100129182114.GA13219@suse.de>
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
	 <m1eil9v0j9.fsf@fess.ebiederm.org> <4B629E7F.5020200@redhat.com>
	 <m1zl3xt49k.fsf@fess.ebiederm.org> <20100129142223.GB12539@suse.de>
	 <1264787848.24455.31.camel@laptop> <20100129181024.GA12934@suse.de>
	 <1264788860.24455.35.camel@laptop>  <20100129182114.GA13219@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 21:10:34 +0100
Message-ID: <1264795834.24455.43.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 10:21 -0800, Greg KH wrote:
> On Fri, Jan 29, 2010 at 07:14:20PM +0100, Peter Zijlstra wrote:
> > On Fri, 2010-01-29 at 10:10 -0800, Greg KH wrote:
> > > On Fri, Jan 29, 2010 at 06:57:28PM +0100, Peter Zijlstra wrote:
> > > > On Fri, 2010-01-29 at 06:22 -0800, Greg KH wrote:
> > > > > 
> > > > > Heh, this whole mess is the very reason we didn't add lockdep support to
> > > > > the driver core.  Nested devices that all look alike from the driver
> > > > > core, are really different objects and the locking lifetimes are
> > > > > separate, but lockdep can't see that. 
> > > > 
> > > > And here I through Alan Stern had a handle on making the driver core
> > > > play nice.
> > > 
> > > It's not the driver core that is the issue here, it's that lockdep can't
> > > handle the tree structure of devices that is represented in the kernel.
> > > 
> > > I don't think it is a driver core problem, but rather, a lockdep issue.
> > 
> > Right, we've been over that and I think I added enough lockdep
> > annotations to make it work for the device tree. At least, Alan and I
> > seemed to agree on that last time we talked about it.
> 
> Ah, I didn't realize that, very nice.
> 
> If so, then this sysfs lock stuff should be able to use those
> annotations and we shouldn't have this issue, right?

I really wouldn't know, I've not yet looked at sysfs to see what the
particular issue is. But possibly, if you say the problem space is
similar.

