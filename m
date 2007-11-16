Return-Path: <linux-kernel-owner+w=401wt.eu-S934851AbXKPVem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851AbXKPVem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934629AbXKPVe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:34:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58165 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934146AbXKPVe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:34:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: Suspend/Resume/Hibernation - bisecting or bug-logs?
Date: Fri, 16 Nov 2007 22:51:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-main <linux-kernel@vger.kernel.org>
References: <20071116161420.e2c57ff6.Kristoffer.Ericson@Gmail.com>
In-Reply-To: <20071116161420.e2c57ff6.Kristoffer.Ericson@Gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711162251.56545.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 17 of November 2007, Kristoffer Ericson wrote:
> Greetings,
> 
> Ive been following your discussion and documentation efforts concerning pm
> in the kernel. This has in the past been a gray area which was hard to find
> information about so kudos.

Thanks!

> I maintain 2 handheld platforms that would benefit greatly from implementing
> proper pm (mainly suspend) but Im having problems bugtracking it. Currently
> the system tries to suspend but fails somewhere and then tries to resume
> (which fails). The end result however is that Im unable to see anything
> (bugmessages...) since the video driver gets deactivated by pm.

That's bad. 

> My question is this: Is bisecting (turning off device support in kernel until
> it works) the best approach when bugtracking pm suspend?  Or is there any
> other logging system that I can use?    

Well, various approaches are possible.

First, you can build as many drivers as possible as modules and boot with
init=/bin/bash .  Then, try to suspend and resume and if that fails, the
problem is somewhere deeper.  If that goes well, one of the drivers is failing
and you'll need to find it (eg. by bisection).

Second, on x86 we have PM_TRACE which uses the RTC to store some debugging
information that can be used later to identify the point of failure.  This
might be portable to your platforms.

Next, you can use my recent patches (available at
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.24-rc2/patches/) to
check how deep the problem is located.

Greetings,
Rafael
