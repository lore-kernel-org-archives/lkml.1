Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbZEZVg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbZEZVg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZEZVgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:36:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55251 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZEZVgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:36:51 -0400
Date: Tue, 26 May 2009 23:36:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@tuxonice.net,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090526213644.GA6287@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905260058.54482.rjw@sisk.pl> <20090526091940.GA29867@elf.ucw.cz> <200905261307.22664.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905261307.22664.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-05-26 13:07:22, Oliver Neukum wrote:
> Am Dienstag, 26. Mai 2009 11:19:40 schrieb Pavel Machek:
> 
> Hello,
> 
> > For small allocations... I still believe we should free a bit of
> > memory for s2ram so that small allocations can be done without
> > problems.
> > 									Pavel
> 
> it is essential that this work. Some subsystems, ie. USB, need to allocate
> memory to do IO. For them to work, small allocations must be possible.
> 
> Now, is this a real issue? Can most devices really save a device state?
> This capability seems to me to be limited to memory mapped IO at best.
> USB devices generally don't save and restore state but bring the device
> into the state it ought to be in, not the state it was in during resumption.

Well, you are resuming, with disk still sleeping. You still need to
submit those URBs. You have same problems as during suspend...

BTW... patch removing that small pool of memory was merged few hours
ago:

[merged] pm-suspend-do-not-shrink-memory-before-suspend.patch

I think it should be reverted.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
