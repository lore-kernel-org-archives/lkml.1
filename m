Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYDIGh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYDIGh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 02:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYDIGhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 02:37:10 -0400
Received: from blaine.gmane.org ([80.91.229.8]:41919 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbYDIGhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 02:37:09 -0400
X-Greylist: delayed 1557 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 02:37:09 EDT
To: Inaky Perez-Gonzalez 
	<public-inaky-VuQAYsv1563Yd54FQh9/CA@hugh.gmane.org>
Cc: Stephen Hemminger 
	<public-stephen.hemminger-ZtmgI6mnKB3QT0dZR+AlfA@hugh.gmane.org>,
       public-wimax-BPSAo7wm5JOHVYUYWc+uSQ@hugh.gmane.org,
       public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-netdev-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
From: Andi Kleen <andi@firstfloor.org>
References: <200804011107.38563.inaky@linux.intel.com>
	<20080408135601.5dad3566@speedy>
	<200804081359.03611.inaky@linux.intel.com>
Date: Wed, 09 Apr 2008 08:10:23 +0200
In-Reply-To: <200804081359.03611.inaky@linux.intel.com> (Inaky Perez-Gonzalez's message of "Tue, 8 Apr 2008 13:59:03 -0700")
Message-ID: <871w5fpnhs.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Apr 2008 06:03:40.0444 (UTC) FILETIME=[755B85C0:01C89A07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Inaky Perez-Gonzalez <inaky-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> writes:
>
> There is almost no inlining because each X only does stuff from itself. If
> there is a need for inlined stuff (I missed it) it should go to one of the
> header files --internal or external.

Inlining gets more and more discouraged. Also longer term I would 
expect that gcc will do inlining over files anyways (it already supports
that, but needs special support in the Makefiles which the kernel
doesn't have). So even with inlining you wouldn't need to merge files
or move code into headers.

> version: I anticipate the wimax API exported to user space is
> going to undergo a lot of changes while we all agree on what
> is the best interface. Because things might break, I want to
> make sure user space stuff can detect that and fail cleanly. 
> Hence the versioning. 

It's still a bad way to do that (I agree with Stephen on that).
Was also always a mess on wireless.

If you don't want expandable TLAs another better alternative to 
versions is ext2 style compatible/incompatible feature bitmaps.

-Andi


