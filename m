Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXE1VAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXE1VAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXE1VAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:00:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4542 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751314AbXE1VAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:00:09 -0400
Date: Mon, 28 May 2007 20:59:51 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Message-ID: <20070528205951.GB5911@ucw.cz>
References: <Pine.LNX.4.44L0.0705281151250.22682-100000@netrider.rowland.org> <200705281943.25129.rjw@sisk.pl> <2c0942db0705281351g450bd0c6u31e634757dfa8ac0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0705281351g450bd0c6u31e634757dfa8ac0@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >In fact, I'd like drivers to use notifiers to actually 
> >load the firmware into
> >memory before hibernation/suspend.  Namely, if there's 
> >PM_PRE_FREEZE, the
> >driver calls request_firmware() from within the 
> >notifier and saves the firmware
> >in memory for future use, if need be.  Later, when 
> >PM_POST_THAW comes, the
> >memory holding the firmware is released.
> >
> >Unfortunately there are drivers that call 
> >request_firmware() directly from
> >.resume() which blocks until timeout expires and fails 
> >anyway.  I just wanted
> >this to fail immediately, without waiting.
> 
> Stupid question time. Wouldn't it just be easier to have
> request_firmware() keep a copy of the firmware once it's 
> been loaded?
> We're not talking about a lot of memory that would be 
> wasted, and that
> way no drivers have to be changed.

Actually, I like this idea. Firmware problems magically disappear.

...unless someone uses x86 emulator in userland to POST graphics card.
You can't 'cache' that. But that's separate problem.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
