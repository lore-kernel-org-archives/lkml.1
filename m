Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZLTAev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZLTAev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 19:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZLTAet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 19:34:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbZLTAes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 19:34:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sun, 20 Dec 2009 01:35:21 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912200053.45988.rjw@sisk.pl> <alpine.LFD.2.00.0912191557320.3712@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912191557320.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912200135.21477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Linus Torvalds wrote:
> 
> On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:
> > > 
> > > Why would it be?
> > 
> > The embedded controller may depend on it.
> 
> Again, I say "why?"
> 
> Anything can be true. That doesn't _make_ everything true. There's no real 
> reason why PnP/ACPI suspend/resume should really care.
> 
> We can try it. Not for 2.6.33, but by the 34 merge window maybe we'll have 
> a patch-series that is ready to be tested, and that aggressively tries to 
> do the devices that matter asynchronously.

Yes, I'd like to have such a patch series for 2.6.34.

So far I've been able to confirm that doing serio+i8042, USB and ACPI battery
asynchronously may give us significant time savings, especially during resume.

> So instead of you trying to make up some idiotic cross-device worries, 
> just see if those worries have any actual background in reality. So far I 
> haven't actually heard anything but "in theory, anything is possible", 
> which is such a truism that it's not even worth voicing.
> 
> That said, I still get the feeling that we'd be even better off simply 
> trying to avoid the whole keyboard reset entirely. Apparently we do it for 
> a few HP laptops. It's entirely possible that we'd be better off simply 
> not _doing_ the slow thing in the first place.

That very well may be the case, but I'm not the right person to confirm or deny
that.

Rafael
