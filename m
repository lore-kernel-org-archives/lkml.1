Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYARIsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYARIsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYARIsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:48:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbYARIsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:48:00 -0500
Date: Fri, 18 Jan 2008 00:47:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zan Lynx <zlynx@acm.org>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: echo mem > /sys/power/state
Message-Id: <20080118004725.dcd132ee.akpm@linux-foundation.org>
In-Reply-To: <20080118083610.GA19792@elte.hu>
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org>
	<1200591411.34145.4.camel@localhost>
	<20080117111355.29554f38.akpm@linux-foundation.org>
	<200801172238.17176.rjw@sisk.pl>
	<20080118083610.GA19792@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 09:36:10 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > Probably it would be more efficient to have the people who wrote the 
> > > code also test it.
> > 
> > Well, that would certainly help.
> > 
> > I do test all of my patches and generally all of the patches I sign 
> > off, but surely that's not enough.
> 
> please add a .config option dependent on CONFIG_DEBUG_KERNEL=y [and 
> default-disabled] that auto-tests suspend/resume functionality 60 
> seconds after hitting user-space (the suspend/resume cycle kept small 
> via a small RTC timeout) and s2ram correctness will be tested _a lot_ 
> more.
> 
> (it doesnt matter if graphics does not resume fine - at least for my 
> tests)
> 
> kprobes had similar problems and it now has a few simple smoke-tests - 
> which i just saw trigger on a patch that i did not notice would break 
> kprobes. I think this should be done for all functionality that is not 
> regularly triggered by a normal distro bootup (and which is easy to 
> overlook in testing).
> 

Seeing as we're so lame about being able to distribute userspace stuff:
create a shell script in /proc/rc.kernel and start teaching initscripts to
run it.  Then we can modify it at will.

I hate me.
