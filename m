Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbYKFJMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbYKFJMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYKFJMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:12:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33442 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbYKFJMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:12:19 -0500
Date: Thu, 6 Nov 2008 10:12:18 +0100
From: Pavel Machek <pavel@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory hotplug
Message-ID: <20081106091218.GA20574@atrey.karlin.mff.cuni.cz>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz> <1225817945.12673.602.camel@nimitz> <20081105093837.e073c373.kamezawa.hiroyu@jp.fujitsu.com> <200811051208.26628.rjw@sisk.pl> <20081106091441.6517c072.kamezawa.hiroyu@jp.fujitsu.com> <20081106101751.14113f24.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106101751.14113f24.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 6 Nov 2008 09:14:41 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Ok, please consider "when memory hotplug happens." 
> > 
> > In general, it happens when
> >   1. memory is inserted to slot.
> >   2. the firmware notifes the system to enable already inserted memory.
> > 
> > To trigger "1", you have to open cover of server/pc. Do you open pc while the system
> > starts hibernation ? for usual people, no.
> > 
> > To trigger "2", the user have special console to tell firmware "enable this memory".
> > Such firmware console or users have to know "the system works well." And, more important,
> > when the system is suspended, the firmware can't do hotplug because the kernel is sleeping.
> > So, such firmware console or operator have to know the system status.
> > 
> > Am I missing some ? Current linux can know PCI/USB hotplug while the system is suspended ?
> > 
> *OFFTOPIC*
> 
> I hear following answer from my friend.
> 
>   - hibernate the system
> 	=> plug USB memory
> 		=> wake up the system
> 			=> panic.

That should work. File a bugzilla if it does not.

>   - hibernate the system
> 	=> unplug USB memory
> 		=> wake up the sytem
> 			=> panic.

That should work ok as long as you unmount the drive first.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
