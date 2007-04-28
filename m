Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbXD1Hqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbXD1Hqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXD1Hqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:46:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36361 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXD1Hqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:46:37 -0400
Date: Sat, 28 Apr 2007 13:15:33 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Allow selective freezing of the system for different events
Message-ID: <20070428074533.GA15607@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200704271737.31192.rjw@sisk.pl> <200704271740.17972.rjw@sisk.pl> <20070428013446.GA20242@in.ibm.com> <20070427232222.1ea7797d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427232222.1ea7797d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 11:22:22PM -0700, Andrew Morton wrote:
> On Sat, 28 Apr 2007 07:04:46 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > This patch
> > * Provides an interface to selectively freeze the system for different events.
> > * Allows tasks to exempt themselves or other tasks from specific freeze
> >   events.
> > * Allow nesting of freezer calls. For eg:
> > 
> > 	freeze_processes(EVENT_A);
> > 	/* Do something with respect to event A */
> > 	.
> > 	.
> > 	.
> > 	freeze_processes(EVENT_B);
> > 	/* Do something with respect to event B */
> > 	.
> > 	.
> > 	.
> > 	thaw_processes(EVENT_B);
> > 	.
> > 	.
> > 	.
> > 	thaw_processes(EVENT_B);
> > 
> > This type of behaviour would be required when cpu hotplug would start
> > using the process freezer, where EVENT_A would be SUSPEND and EVENT_B
> > would be HOTPLUG_CPU.
> > 
> > This patch applies on the top of 2.6.21-rc7-mm2 + Rafael's freezer
> > changes from http://lkml.org/lkml/2007/4/27/302.
> 
> I think I'll duck this.  We have more than enough kthread/freezer/etc work
> queued for 2.6.22. 

Sure, not a problem :-)

I just wanted to get a sense, if this was a right way to do it. 
Besides, I am plannning to send it again once I port the cpuhotplug
patches on top of all these changes and get some satisfactory numbers.

> Let's please for now concentrate on reviewing and
> testing the existing changes.  Once that has all landed and settled in,
> let's start thinking about the next round.
> 

Ok.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
