Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861Ab0A2Uax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0A2Uax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029Ab0A2Uaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:30:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34690 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0A2Uav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:30:51 -0500
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Cong Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
	<m1eil9v0j9.fsf@fess.ebiederm.org> <4B629E7F.5020200@redhat.com>
	<m1zl3xt49k.fsf@fess.ebiederm.org> <20100129142223.GB12539@suse.de>
	<1264787848.24455.31.camel@laptop> <20100129181024.GA12934@suse.de>
	<1264788860.24455.35.camel@laptop> <20100129182114.GA13219@suse.de>
	<1264795834.24455.43.camel@laptop>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 29 Jan 2010 12:30:46 -0800
In-Reply-To: <1264795834.24455.43.camel@laptop> (Peter Zijlstra's message of "Fri\, 29 Jan 2010 21\:10\:34 +0100")
Message-ID: <m1y6jgpsax.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, 2010-01-29 at 10:21 -0800, Greg KH wrote:
>> On Fri, Jan 29, 2010 at 07:14:20PM +0100, Peter Zijlstra wrote:
>> > On Fri, 2010-01-29 at 10:10 -0800, Greg KH wrote:
>> > > On Fri, Jan 29, 2010 at 06:57:28PM +0100, Peter Zijlstra wrote:
>> > > > On Fri, 2010-01-29 at 06:22 -0800, Greg KH wrote:
>> > > > > 
>> > > > > Heh, this whole mess is the very reason we didn't add lockdep support to
>> > > > > the driver core.  Nested devices that all look alike from the driver
>> > > > > core, are really different objects and the locking lifetimes are
>> > > > > separate, but lockdep can't see that. 
>> > > > 
>> > > > And here I through Alan Stern had a handle on making the driver core
>> > > > play nice.
>> > > 
>> > > It's not the driver core that is the issue here, it's that lockdep can't
>> > > handle the tree structure of devices that is represented in the kernel.
>> > > 
>> > > I don't think it is a driver core problem, but rather, a lockdep issue.
>> > 
>> > Right, we've been over that and I think I added enough lockdep
>> > annotations to make it work for the device tree. At least, Alan and I
>> > seemed to agree on that last time we talked about it.
>> 
>> Ah, I didn't realize that, very nice.
>> 
>> If so, then this sysfs lock stuff should be able to use those
>> annotations and we shouldn't have this issue, right?
>
> I really wouldn't know, I've not yet looked at sysfs to see what the
> particular issue is. But possibly, if you say the problem space is
> similar.

We get false positives when the code of a sysfs attribute
synchronously removes other sysfs attributes.  In general that is not
safe due to hotplug etc, but there are specific instances of static
sysfs entries like the pm_core where it appears to be safe.

I am not familiar with the device core lockdep issues.  Are they similar?

Eric


