Return-Path: <linux-kernel-owner+w=401wt.eu-S1751650AbXGGUsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbXGGUsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbXGGUs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:48:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34295 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbXGGUsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:48:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: problem 1 (was Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway))
Date: Sat, 7 Jul 2007 22:55:48 +0200
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Paul Mackerras <paulus@samba.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <20070705135758.GB22177@srcf.ucam.org> <20070707120827.GA3111@elf.ucw.cz>
In-Reply-To: <20070707120827.GA3111@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707072255.48975.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 7 July 2007 14:08, Pavel Machek wrote:
> Hi!
> 
> > > Now, if kernel needs FUSE services for some reason (that's the problem
> > > we hit in s2ram case, right?), we have a deadlock.
> > > 
> > > So main problem still seems to be "kernel should not depend on
> > > userland services during suspend", refrigerator or not.
> > 
> > And also "Userland should not depend on userland services", which is 
> > rather more of a problem.
> 
> No, that's not a problem. Or rather, that's different problem, called
> "problem 2" (fuse causes freezer to fail to stop processes).
> 
> But we still have "problem 1" here: after devices are suspended,
> kernel tries to use fuse's services. That is not going to work, one
> way or another, because devices are suspended and userland can't work
> reliably.
> 
> (Aha, it _may_ be it is kernel tries to use fuse's services after
> freezing userland but before freezing devices. I don't think it is).
> 
> To solve "problem 1", we need to know which part of kernel asks for
> fuse services. sysrq-t trace is likely to tell us. Can someone repeat
> the "problem 1" scenario (freezer succeeds but then it deadlocks), and
> produce sysrq-t trace? That way we can solve "problem 1".

Well, such a trace would be helpful in any case.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
