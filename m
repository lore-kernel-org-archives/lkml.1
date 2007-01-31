Return-Path: <linux-kernel-owner+w=401wt.eu-S932948AbXAaKa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbXAaKa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXAaKa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:30:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51328 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932948AbXAaKa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:30:56 -0500
Date: Wed, 31 Jan 2007 11:30:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.name>, pm list <linux-pm@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] question on resume()
Message-ID: <20070131103045.GA19640@elf.ucw.cz>
References: <200701291206.39637.oneukum@suse.de> <200701311004.19477.oneukum@suse.de> <20070131093653.GA19643@elf.ucw.cz> <200701311114.55685.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701311114.55685.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > So, this means, on suspend():
> > > 
> > > 1. Don't worry about TASK_UNINTERRUPTIBLE
> > > 2. Do worry about TASK_INTERRUPTIBLE
> > > We have to cease IO and must not call wake_up_interruptible()
> > 
> > "cease IO"? No, I believe it is enough not to start new I/O. Userspace
> > is frozen at that point, it can't ask you to do I/O.
> >
> > > Isn't that a race until suspend() is called?
> > 
> > I do not think so.
> 
> What about URBs in flight which are waited for with TASK_INTERRUPTIBLE?

Same thing as if someone sent a signal to that process. (We are
talking about user processes here, right? Kernel threads have to take
care themselves).

> > > On resume():
> > > 
> > > 1. Don't worry about TASK_UNINTERRUPTIBLE
> > > 2. Do not restart IO that may call wake_up_interruptible()
> > > 
> > > When do we restart such IO?
> > 
> > We reuse signal handling code to do that for us. It is same situation
> > as when someone signals task doing I/O.
> 
> What happens to tasks in TASK_INTERRUPTIBLE which are frozen?
> Are they interrupted and frozen?

Interrupted with fake signal, then frozen, yes.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
