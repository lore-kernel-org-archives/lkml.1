Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbYDEC1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbYDEC1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 22:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYDEC1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 22:27:34 -0400
Received: from rtr.ca ([76.10.145.34]:2584 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbYDEC1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 22:27:33 -0400
Message-ID: <47F6E393.10904@rtr.ca>
Date: Fri, 04 Apr 2008 22:27:31 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, david-b@pacbell.net,
       oliver@neukum.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.25-rc7/8: Another resume regression
References: <200803220259.48534.rjw@sisk.pl> <alpine.LFD.1.00.0803311118120.14670@woody.linux-foundation.org> <47F13B8F.1000003@rtr.ca> <47F52AAC.8090005@rtr.ca>
In-Reply-To: <47F52AAC.8090005@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Hi,
> 
> Okay, USB now works fine on resume after fixing the iaa_watchdog issue.
> 
> But twice now, once before that fix, and again just a minute ago,
> my machine has failed completely to resume after suspend-to-RAM.
> 
> Again, resume here is 100% reliable in 2.6.24 and earlier.
> 
> Symptoms: the usual:
> 
>  -- 2.6.25-rc8 (and -rc7 earlier), plus USB fix.
>  -- not reproduceable on demand.
>  -- black screen of death -- no backlight, no kernel messages.
>  -- no hard drive activity.
>  -- no alt-sysrq-anything.
>  -- 5 second hold of the power button to poweroff and then recover.
> 
> Not much info to go on, but it's worth knowing there's an issue here 
> somewhere.
..

Mmmm... Now that 2.6.25-rc* is usable here, there's another symptom
that's been happening regularly enough that it's got to be a regression
of some sort.

This machine has an ATI X1400 video card, which doesn't work with any
open source X server that I know of.  Maybe latest RadeonHD would work
but it didn't when I tried it in January.

So I'm using the ATI binary fglrx X server, but without their kernel module,
so no 3D acceleration (fine.. only affects Google Earth, really).

Now.. on 2.6.25, after a suspend/resume cycle (or three), the framebuffer
frequently starts going wonky.  "snowy" pixels appear, and stay.
Just a moment ago here, the entire background changed to zebra stripes.

And so on..  Peculiar stuff.

I'm wondering if something to do with video mode switching,
or video register save/restore, has changed since 2.6.24.
Because it's broken in 2.6.25, yet works fine in all earlier kernels.

???

