Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbXD1Xpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbXD1Xpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXD1Xpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:45:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754425AbXD1Xpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:45:34 -0400
Date: Sat, 28 Apr 2007 16:45:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Back to the future.
In-Reply-To: <200704290103.38409.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704281640480.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704281950.30405.rjw@sisk.pl>
 <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org>
 <200704290103.38409.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Rafael J. Wysocki wrote:
> 
> OK, more precisely: fs-related threads should not try to process their queues,
> etc., after the snapshot is done, because that may cause some fs data to be
> written at that time and then the fs in question may be corrupted after the
> restore.  Not all of the I/O in general, fs data.

But that's not true _either_. That's only true because right now I think 
we cannot even suspend to a swapfile (I might be wrong). 

If you have a swapfile on a filesystem, you'd need those fs queues 
running!

> Well, I'm not sure whether or not that still would have been the case if we had
> stopped to freeze kernel threads for the hibernation/suspend.

Did you miss the email where Paul pointed out that Mac/PowerPC didn't use 
to do any of this? And apparently never had any issues with it? And 
probably worked more reliably several years ago than suspend/hibernation 
does _today_?

Ie we do have history of _not_ freezing things.  The freezing came later, 
and came with the subsystem that had more problems..

		Linus
