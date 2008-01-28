Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYA1QeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYA1QeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYA1Qd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:33:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35645 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbYA1Qdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:33:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation on x86-64 (bisected)
Date: Mon, 28 Jan 2008 17:31:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <200801272229.48955.rjw@sisk.pl> <479D3287.1050604@redhat.com> <200801281231.51545.rjw@sisk.pl>
In-Reply-To: <200801281231.51545.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281731.37636.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, Rafael J. Wysocki wrote:
> On Monday, 28 of January 2008, Steven Rostedt wrote:
> > Rafael J. Wysocki wrote:
> > 
> > > No, this isn't the WARN_ON().
> > > 
> > >> this does have the feel of being scheduling related, but are you 
> > >> absolutely sure about the precise identity of the patch?
> > > 
> > > Actually, not quite.  That's why I have verified it and found that another
> > > patch is really responsible for the issue, namely:
> > > 
> > > commit 82a1fcb90287052aabfa235e7ffc693ea003fe69
> > > Author: Ingo Molnar <mingo@elte.hu>
> > > Date:   Fri Jan 25 21:08:02 2008 +0100
> > > 
> > >     softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks
> > 
> > Are you getting a bunch of prints from the softlockup detector in dmesg?
> 
> No, I don't.  In fact, I don't get _any_ messages from it whatsoever.
> 
> > I wonder if the detector can detect a long timeout caused by suspend and 
> > resume and if not is triggering false positives?
> 
> I'm not sure, but the code is supposed to be suspend-aware, IIRC.  However,
> I'm seeing a similar symptom on poweroff on an SMP x86-64 box, so it may be
> more directly related to the CPU hotplug.  I'll try to verify that.

As I expected, the delay is also observable when I do:

echo 0 > /sys/devices/system/cpu/cpu1/online

(it's variable, between 3 and 30 seconds).  Again, no messages appear in dmesg
when this happens.

I suspect I'll be able to reproduce it on another x86-64 SMP machine (I'm going
to try that later today).

Thanks,
Rafael
