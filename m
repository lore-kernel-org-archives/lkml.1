Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYCMQVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYCMQVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYCMQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:21:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56006 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYCMQVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:21:06 -0400
Date: Thu, 13 Mar 2008 09:19:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: hackbench regression since 2.6.25-rc
Message-Id: <20080313091921.834d2532.randy.dunlap@oracle.com>
In-Reply-To: <20080313151413.GA14045@suse.de>
References: <1205394417.3215.85.camel@ymzhang>
	<20080313151413.GA14045@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 08:14:13 -0700 Greg KH wrote:

> On Thu, Mar 13, 2008 at 03:46:57PM +0800, Zhang, Yanmin wrote:
> > Comparing with 2.6.24, on my 16-core tigerton, hackbench process mode has about
> > 40% regression with 2.6.25-rc1, and more than 20% regression with kernel
> > 2.6.25-rc4, because rc4 includes the reverting patch of scheduler load balance.
> > 
> > Command to start it.
> > #hackbench 100 process 2000
> > I ran it for 3 times and sum the values.
> > 
> > I tried to investiagte it by bisect.
> > Kernel up to tag 0f4dafc0563c6c49e17fe14b3f5f356e4c4b8806 has the 20% regression.
> > Kernel up to tag 6e90aa972dda8ef86155eefcdbdc8d34165b9f39 hasn't regression.
> > 
> > Any bisect between above 2 tags cause kernel hang. I tried to checkout to a point between
> > these 2 tags for many times manually and kernel always paniced.
> 
> Where is the kernel panicing?  The changeset right after the last one
> above: bc87d2fe7a1190f1c257af8a91fc490b1ee35954, is a change to efivars,
> are you using that in your .config?
> 
> > All patches between the 2 tags are on kobject restructure. I guess such restructure
> > creates more cache miss on the 16-core tigerton.
> 
> Nothing should be creating kobjects on a normal load like this, so a
> regression seems very odd.  Unless the /sys/kernel/uids/ stuff is
> triggering this?
> 
> Do you have a link to where I can get hackbench (google seems to find
> lots of reports with it, but not the source itself), so I can test to
> see if we are accidentally creating kobjects with this load?

The version that I see referenced most often (unscientifically :)
is somewhere under people.redhat.com/mingo/, like so:
http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c


---
~Randy
