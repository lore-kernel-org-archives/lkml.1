Return-Path: <linux-kernel-owner+w=401wt.eu-S936161AbXGMUsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936161AbXGMUsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761134AbXGMUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:48:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760340AbXGMUsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:48:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 22:55:37 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, david@lang.hm,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <Pine.LNX.4.44L0.0707131146340.2555-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707131146340.2555-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707132255.39077.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 July 2007 17:50, Alan Stern wrote:
> On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:
> 
> > Okay, I have thought it through and I think that, as an initial step, we can do
> > something like this:
> > 
> > - preload the image-saving kernel before hibernation
> > - in the hibernation code path replace device_suspend() with the shutting down of
> >   all devices without unregistering them (not very nice, but should be sufficient
> >   for a while)
> > - when we've called device_power_down() and save_processor_state(), jump to
> >   the image-saving kernel and let it run
> > - make the image-saving kernel set up everything, save the image without
> >   starting any user space (we may use the existing image-saving code for this
> >   purpose, with some modifications) and power off the system (or make it enter
> >   S4)
> > - use the existing restoration code to load the image and jump to the
> >   hibernated kernel
> > - in the restore code patch replace device_resume() with the reprobing of all
> >   devices.
> > 
> > Comments?
> 
> I doubt that re-probing devices will work.  The probe routine won't 
> expect there to be any registered children, so it will try to 
> re-register them.

I didn't mean to use .probe() for that.  I just used the term "reprobe" as
similar to "reinit", but not exactly the same.

> On the other hand, post_restore methods could be written to expect 
> something like this.

Yes, that's what I'm thinking of.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
