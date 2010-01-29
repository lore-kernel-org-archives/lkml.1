Return-Path: <linux-kernel-owner+w=401wt.eu-S1752298Ab0A2SLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0A2SLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254Ab0A2SLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:11:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:59805 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab0A2SLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:11:30 -0500
Date: Fri, 29 Jan 2010 10:10:24 -0800
From: Greg KH <gregkh@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Cong Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
Message-ID: <20100129181024.GA12934@suse.de>
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
 <m1eil9v0j9.fsf@fess.ebiederm.org>
 <4B629E7F.5020200@redhat.com>
 <m1zl3xt49k.fsf@fess.ebiederm.org>
 <20100129142223.GB12539@suse.de>
 <1264787848.24455.31.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264787848.24455.31.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 06:57:28PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-29 at 06:22 -0800, Greg KH wrote:
> > 
> > Heh, this whole mess is the very reason we didn't add lockdep support to
> > the driver core.  Nested devices that all look alike from the driver
> > core, are really different objects and the locking lifetimes are
> > separate, but lockdep can't see that. 
> 
> And here I through Alan Stern had a handle on making the driver core
> play nice.

It's not the driver core that is the issue here, it's that lockdep can't
handle the tree structure of devices that is represented in the kernel.

I don't think it is a driver core problem, but rather, a lockdep issue.

thanks,

greg k-h
