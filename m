Return-Path: <linux-kernel-owner+w=401wt.eu-S932854AbXAaJhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbXAaJhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932857AbXAaJhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:37:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59326 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932854AbXAaJhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:37:05 -0500
Date: Wed, 31 Jan 2007 10:36:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.name>, pm list <linux-pm@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] question on resume()
Message-ID: <20070131093653.GA19643@elf.ucw.cz>
References: <200701291206.39637.oneukum@suse.de> <200701310940.26040.oliver@neukum.name> <200701310949.04110.rjw@sisk.pl> <200701311004.19477.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701311004.19477.oneukum@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, it will.  The process freezer can only return success if there are no more
> > TASK_UNINTERRUPTIBLE tasks.  Otherwise it fails (after a timeout).
> 
> So, this means, on suspend():
> 
> 1. Don't worry about TASK_UNINTERRUPTIBLE
> 2. Do worry about TASK_INTERRUPTIBLE
> We have to cease IO and must not call wake_up_interruptible()

"cease IO"? No, I believe it is enough not to start new I/O. Userspace
is frozen at that point, it can't ask you to do I/O.

> Isn't that a race until suspend() is called?

I do not think so.

> On resume():
> 
> 1. Don't worry about TASK_UNINTERRUPTIBLE
> 2. Do not restart IO that may call wake_up_interruptible()
> 
> When do we restart such IO?

We reuse signal handling code to do that for us. It is same situation
as when someone signals task doing I/O.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
