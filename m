Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbYAYIBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbYAYIBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbYAYHr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:47:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2075 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759871AbYAYHrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:47:55 -0500
Date: Fri, 25 Jan 2008 07:47:46 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH -mm 5/5] b43: Avoid unregistering device objects during suspend
Message-ID: <20080125074746.GC4134@ucw.cz>
References: <200801250127.21966.rjw@sisk.pl> <200801250137.34275.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801250137.34275.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-01-25 01:37:33, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Modify the b43 driver to avoid deadlocking suspend and resume,
> which happens as a result of attempting to unregister device objects
> locked by the PM core during suspend/resume cycles.  Also, make it
> use a suspend-safe method of unregistering device object in the
> resume error path.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Michael Buesch <mb@bu3sch.de>

Maybe we should have global suspend_in_progress (or maybe system_state
== suspending?) and automatically switch to schedule_removal() while
it is set?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
