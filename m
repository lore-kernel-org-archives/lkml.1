Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbXEYJwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbXEYJwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXEYJwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:52:23 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:42199 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbXEYJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:52:22 -0400
To: mingo@elte.hu
CC: chris@atlee.ca, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       tglx@linutronix.de
In-reply-to: <20070524210153.GB19672@elte.hu> (message from Ingo Molnar on
	Thu, 24 May 2007 23:01:53 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524125453.GA7554@elte.hu> <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu>
Message-Id: <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 May 2007 11:51:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 2.6.22-rc2, only EVENT_TRACE - boots, can't rerpoduce
> > 2.6.21-vanila - can reproduce
> > 2.6.21-rt7, trace options off - can reproduce
> > 2.6.21-rt7, trace options on - can't reproduce
> > 
> > Possibly something timing related, that's altered by the trace code. I 
> > tried the trace kernel without starting the trace app, but still no 
> > bug.
> > 
> > Any other ideas?
> 
> perhaps try 2.6.21-rt7 with EVENT_TRACE on (the other trace options off) 
> - does that hide the bug too?

The option itself doesn't hide the bug this time, I got one freeze
pretty quickly.  But after starting the trace-it-1sec loop, I couldn't
get it any more.

Normally I get a freeze after 3-5 minutes of testing, but with
trace-it-1sec there's still nothing after 30 minutes.

If I stop trace-it, and do "echo 0 > /proc/sys/kernel/trace_enabled",
I get the freeze again. It's a perfect heisenbug.

This issue came up when I was testing a userspace fuse bug, and now
the reporter of that bug (added to CC) says that he also sometimes
experienced a hard lockup during testing but ignored it up to now.  So
we may yet get some info from him.

It could be something fuse related, but it's very hard to imagine how
fuse could trigger such a low-level problem.

Miklos
