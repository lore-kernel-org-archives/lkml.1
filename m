Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbXGHNsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbXGHNsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXGHNs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:48:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36095 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbXGHNs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:48:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Sun, 8 Jul 2007 15:55:51 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0707061039380.3737-100000@iolanthe.rowland.org> <200707080108.17371.rjw@sisk.pl> <20070708120933.GA3866@ucw.cz>
In-Reply-To: <20070708120933.GA3866@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200707081555.53094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 July 2007 14:09, Pavel Machek wrote:
> Hi!
> 
> > > And then you will face the problem of a user task doing I/O during 
> > > hibernate after the atomic snapshot has been made.
> > 
> > I don't think that this is possible in normal conditions.  It would be possible
> > if, for example, the task were waiting for an unavailable resource and that
> > resource became available after the hibernation image had been created.
> > In that case, however, to do any damage, the task would have to cause some
> > filesystem-related data to be flushed in the same syscall (ie. before returning
> > to user space).
> 
> I agree that it is relatively unlikely to trigger (if you avoid
> freezing the tasks that were uninterruptible for long), but it will
> trigger in error cases etc.

Yes, it will.

> > Such situations may be prevented by a mechanizm detecting if any uniterruptible
> > and freezing task has been woken up after creating the image and aborting the
> > hibernation in that cases.  For this purpose, we only need to add an
> > appropriate condition to try_to_wake_up() and make it start to trigger after,
> > for example, enabling the nonboot CPUs.
> 
> I don't know how to do that mechanism... but if we knew where to trap
> filesystem writes, we could simply freeze at that point, and at that
> point only, no?

>From the image/filesystems integrity standpoint, yes, that should be
sufficient.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
