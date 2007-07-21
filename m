Return-Path: <linux-kernel-owner+w=401wt.eu-S938559AbXGULqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938559AbXGULqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 07:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbXGULqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 07:46:35 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:37248 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbXGULqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 07:46:34 -0400
To: rjw@sisk.pl
CC: miltonm@bga.com, stern@rowland.harvard.edu, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org, jbms@cmu.edu
In-reply-to: <200707202302.07116.rjw@sisk.pl>
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <200707192228.05136.rjw@sisk.pl> <44037b3d409370919bddd8710e6064fc@bga.com> <200707202302.07116.rjw@sisk.pl>
Message-Id: <E1ICDNw-0008HC-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 21 Jul 2007 13:44:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem with FUSE is related to the fact that the freezer can't
> freeze uninterruptible tasks and we said that perhaps we might avoid
> it if FUSE was made freezing-aware.  Still, no one has gone in this
> direction and I don't know of any plans to do that.

I thought we have fully explored this direction.  Lots of emails, and
an IRC session with Pavel.  Conclusion:

 - It can't be done without VFS surgery + adding various hacks to fuse

 - VFS surgery for the sake of a working suspend is not realistic

Although removing the freezer seems the cleanest solution, I'm not
saying the freezer can't be fixed up in the mean time.

Allowing tasks to remain in uninterruptible sleep seemed a nice way to
get around the fuse issues.  What was the problem with that patch?  It
was something that was supposed to have been tested in suspend2,
wasn't it?

The other one (trying to wake up task, so that may make other tasks
freezable) didn't seem such a good approach to me.

The theory is quite simple: while and after suspending devices, no
tasks must be touching said devices.

The very cleanest way to do this is in the drivers.  The very simplest
way is the current freezer.  But may be there are possibilities
between these two extremes.

But I can almost guarantee you, that any attempt at fixing the issues
though fuse will just result in an even bigger mess than what we
currently have.

Miklos
