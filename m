Return-Path: <linux-kernel-owner+w=401wt.eu-S1763400AbXFBWrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763400AbXFBWrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760793AbXFBWrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:47:16 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760729AbXFBWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:47:16 -0400
Date: Sat, 2 Jun 2007 15:46:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Greaves <david@dgreaves.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression
In-Reply-To: <4661EFBB.5010406@dgreaves.com>
Message-ID: <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org>
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl>
 <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl>
 <4661EFBB.5010406@dgreaves.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Jun 2007, David Greaves wrote:
> 
> Then 2.6.22-rc3 again but CONFIG_DISABLE_CONSOLE_SUSPEND=y
> It suspended again.
> Froze on restore.
> Screen photo here:
> http://www.dgreaves.com/pub/2.6.21-rc3-resume-failure.jpg

Ok, it wasn't a hidden oops. The DISABLE_CONSOLE_SUSPEND=y thing sometimes 
shows oopses that are otherwise hidden, but at other times it just causes 
more problems (hard hangs when trying to display something on a device 
that is suspended, or behind a bridge that got suspended).

In your case, the screen output just shows normal resume output, and it 
apparently just hung for some unknown reason. It *may* be worth trying to 
do a SysRQ + 't' thing to see what tasks are running (or rather, not 
running), but since you won't be able to capture it, it's probably not 
going to be useful.

> Then 2.6.22-rc3 again but CONFIG_DISABLE_CONSOLE_SUSPEND=y
> This time, before suspending I unmounted my xfs/lvm/raid6 filesystem.
> Just a umount, I left the devices/array up.
> It suspended again.
> This time it resumed without fault.

It would be interesting to see what triggered it, since it apparently 
worked before. So yes, a bisection would be great.

			Linus
