Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532Ab0A3Fbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0A3Fbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 00:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424Ab0A3Fbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 00:31:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:45991 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab0A3Fba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 00:31:30 -0500
Date: Fri, 29 Jan 2010 21:30:08 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
Message-ID: <20100130053008.GD22459@suse.de>
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain> <m1eil9v0j9.fsf@fess.ebiederm.org> <4B629E7F.5020200@redhat.com> <m1zl3xt49k.fsf@fess.ebiederm.org> <20100129142223.GB12539@suse.de> <m1d40sr74d.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d40sr74d.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 12:25:22PM -0800, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > Heh, this whole mess is the very reason we didn't add lockdep support to
> > the driver core.  Nested devices that all look alike from the driver
> > core, are really different objects and the locking lifetimes are
> > separate, but lockdep can't see that.
> >
> > I suggest we just remove the original patch, as it seems to be causing
> > way too many problems.
> >
> > Any objections to that?
> 
> I think the hit rate for real problems has been about 25-50%.  Of the
> false positives a lot of those have been, code that is at least
> questionable.
> 
> Furthermore there are problems we can find this way that we won't know
> about any other way.  Unfortunately I haven't had much time to do
> anything kernel related lately, or I would have done more with this.
> My comment was about simply about finding a good way to increase the
> signal to noise ration so investigations can reasonably start with the
> presumption that code lockdep is complaining about real problems.
> 
> The deadlocks that we can hit in sysfs are very nasty to find, they
> have persisted for years, and they pop back up after they are fixed.
> So far the pain from lockdep annotations seems a lot lower.
> 
> Right now annotating with subclasses as Amerigo is attempting will work,
> and remove the false positives.  I was simply hoping to find a faster
> way to get there.
> 
> So yes, I do object to removing the original patch.  Let's put in the
> work to find a good path to remove the handful of cases that cause
> false positives.

Ok, that sounds good to me.

thanks,

greg k-h
