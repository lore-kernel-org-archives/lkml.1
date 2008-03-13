Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbYCMRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbYCMRMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYCMRMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:12:12 -0400
Received: from ns1.suse.de ([195.135.220.2]:38132 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbYCMRML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:12:11 -0400
Date: Thu, 13 Mar 2008 10:12:02 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: hackbench regression since 2.6.25-rc
Message-ID: <20080313171202.GA5233@suse.de>
References: <1205394417.3215.85.camel@ymzhang> <20080313151413.GA14045@suse.de> <20080313091921.834d2532.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313091921.834d2532.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 09:19:21AM -0700, Randy Dunlap wrote:
> On Thu, 13 Mar 2008 08:14:13 -0700 Greg KH wrote:
> 
> > On Thu, Mar 13, 2008 at 03:46:57PM +0800, Zhang, Yanmin wrote:
> > > Comparing with 2.6.24, on my 16-core tigerton, hackbench process mode has about
> > > 40% regression with 2.6.25-rc1, and more than 20% regression with kernel
> > > 2.6.25-rc4, because rc4 includes the reverting patch of scheduler load balance.
> > > 
> > > Command to start it.
> > > #hackbench 100 process 2000
> > > I ran it for 3 times and sum the values.
> > > 
> > > I tried to investiagte it by bisect.
> > > Kernel up to tag 0f4dafc0563c6c49e17fe14b3f5f356e4c4b8806 has the 20% regression.
> > > Kernel up to tag 6e90aa972dda8ef86155eefcdbdc8d34165b9f39 hasn't regression.
> > > 
> > > Any bisect between above 2 tags cause kernel hang. I tried to checkout to a point between
> > > these 2 tags for many times manually and kernel always paniced.
> > 
> > Where is the kernel panicing?  The changeset right after the last one
> > above: bc87d2fe7a1190f1c257af8a91fc490b1ee35954, is a change to efivars,
> > are you using that in your .config?
> > 
> > > All patches between the 2 tags are on kobject restructure. I guess such restructure
> > > creates more cache miss on the 16-core tigerton.
> > 
> > Nothing should be creating kobjects on a normal load like this, so a
> > regression seems very odd.  Unless the /sys/kernel/uids/ stuff is
> > triggering this?
> > 
> > Do you have a link to where I can get hackbench (google seems to find
> > lots of reports with it, but not the source itself), so I can test to
> > see if we are accidentally creating kobjects with this load?
> 
> The version that I see referenced most often (unscientifically :)
> is somewhere under people.redhat.com/mingo/, like so:
> http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c

Great, thanks for the link.

In using that version, I do not see any kobjects being created at all
when running the program.  So I don't see how a kobject change could
have caused any slowdown.

Yanmin, is the above link the version you are using?

Hm, running with "hackbench 100 process 2000" seems to lock up my
laptop, maybe I shouldn't run 4000 tasks at once on such a memory
starved machine...

thanks,

greg k-h
