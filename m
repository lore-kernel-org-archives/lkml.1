Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXLaNrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXLaNrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 08:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXLaNrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 08:47:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36503 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbXLaNrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 08:47:05 -0500
Date: Mon, 31 Dec 2007 14:44:47 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20071231144447.GD26339@ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz> <200712271041.30923.oliver@neukum.org> <20071229235134.GC17823@ucw.cz> <200712301739.42192.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712301739.42192.oliver@neukum.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-30 17:39:42, Oliver Neukum wrote:
> Am Sonntag, 30. Dezember 2007 00:51:34 schrieb Pavel Machek:
> > Hi!
> > 
> > > > ... I also don't need to call any suspend() routines, because all the
> > > > drivers are already suspended, right?
> > > 
> > > Well, you have a number of devices which cannot do runtime pm.
> > > They can do suspend/resume with the whole system. For them these
> > > operations mean saving/restoring state.
> > > So for these devices implementing autosuspend makes no sense.
> > > They would sensibly do only idle/busy detection.
> > 
> > Yep... Let's call busy/idle detection and save/restore state
> > "autosuspend" for those devices. It does not save any power, but it
> > can be viewed as "kind-of-suspend". (No, I do not have this kind of
> > details ready).
> 
> Well, you probably would have to walk through all devices and check
> all devices are either suspended or can be suspended. That would mean
> struct device has to be extended to show common attributes.
> 
> But what's wrong with calling suspend() the conventional way once you've
> decided to go into sleepy mode?

I'm not sure if it can be done in non-racy way. It is different from
"conventional" suspend(): you can still have userland requests after
this suspend(), and you should abort auto-sleep if you get one. (As
opposed to blocking in system suspend case).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
