Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYKFIrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYKFIrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYKFIr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:47:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34382 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYKFIr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:47:28 -0500
Date: Thu, 6 Nov 2008 09:47:27 +0100
From: Pavel Machek <pavel@suse.cz>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory hotplug
Message-ID: <20081106084727.GC11095@atrey.karlin.mff.cuni.cz>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz> <1225817945.12673.602.camel@nimitz> <20081105093837.e073c373.kamezawa.hiroyu@jp.fujitsu.com> <200811051208.26628.rjw@sisk.pl> <20081106091441.6517c072.kamezawa.hiroyu@jp.fujitsu.com> <1225931281.11514.27.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225931281.11514.27.camel@nimitz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > To trigger "2", the user have special console to tell firmware "enable this memory".
> > Such firmware console or users have to know "the system works well." And, more important,
> > when the system is suspended, the firmware can't do hotplug because the kernel is sleeping.
> > So, such firmware console or operator have to know the system status.
> > 
> > Am I missing some ? Current linux can know PCI/USB hotplug while the
> > system is suspended ?
> 
> * echo 'disk' > /sys/power/state
> * count number of pages to write to disk
> * turn all interrupts off
> * copy pages to disk
> * power down
> 
> I think the race we're trying to close is the one between when we count
> pages and when we turn interrupts off.  I assume that there is a reason
> that we don't do the *entire* hibernation process with interrupts off,
> probably because it would "lock" the system up for too long, and can
> even possibly fail.

We need interrupts to write pages to the disk.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
