Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbXDINLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbXDINLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXDINLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:11:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54541 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbXDINLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:11:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFD] CPU hotplug and suspend
Date: Mon, 9 Apr 2007 15:14:55 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <200704061732.32712.rjw@sisk.pl> <20070409140352.GB3864@ucw.cz>
In-Reply-To: <20070409140352.GB3864@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704091514.56167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 9 April 2007 16:03, Pavel Machek wrote:
> > Currently, we use the CPU hotplug to disable nonboot CPUs in the suspend code
> > paths, but with the recent change of code ordering (ie. nonboot CPUs are
> > disabled after freezing tasks _and_ devices) it has become quite troublesome.
> > The reason of this is that there are some CPU hotplug notifiers registered and
> > called on each run of cpu_up()/cpu_down() that assume the system to be fully
> > functional, which is not the case during the suspend.  Moreover, at least some
> > of them do things that are not really necessary for disabling or enabling the
> > nonboot CPUs.
> 
> Right.
> 
> > The advantage of using the CPU hotplug (in its current form) for suspending is
> > that if some CPUs don't reappear during the resume, we are safe.  Still, I
> > think it would be more appropriate, and simpler in the long run, to notify the
> > interested subsystems _only_ if one (or more) CPUs are not functional after the
> > resume. 
> 
> I'm afraid that adding 'cpu not there so simulate unplug' path will
> make it complex, and prone to failure, as _noone_ is going to test it.

Does it mean you think we should stick with the current approach and sort out
all issues as they show up, or should we go for not using the CPU hotplug for
suspending without implementing the 'cpu not there so simulate unplug' path
at all (eg. we can fail the resume instead)?

Rafael
