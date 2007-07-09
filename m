Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbXGIPga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbXGIPga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbXGIPgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:36:23 -0400
Received: from rwcrmhc11.comcast.net ([216.148.227.151]:38996 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXGIPgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:36:22 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
References: <Pine.LNX.4.44L0.0707091043480.3851-100000@iolanthe.rowland.org>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 09 Jul 2007 11:36:13 -0400
In-Reply-To: <Pine.LNX.4.44L0.0707091043480.3851-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Mon\, 9 Jul 2007 10\:45\:56 -0400 \(EDT\)")
Message-ID: <87tzsdvbbm.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Mon, 9 Jul 2007, Jeremy Maitin-Shepard wrote:
>> Pavel Machek <pavel@ucw.cz> writes:
>> 
>> [snip]
>> 
>> > I don't know how to do that mechanism... but if we knew where to trap
>> > filesystem writes, we could simply freeze at that point, and at that
>> > point only, no?
>> 
>> Any operation at all that has an external effect must not occur after
>> the snapshot is made; otherwise, there will be random hard-to-find
>> corruptions and other problems occurring as a result.  Thus, for
>> example, any writes (either directly or indirectly through e.g. a
>> filesystem) to non-volatile storage, any network traffic, any
>> communication with hardware like a printer must be prevented after the
>> snapshot.

> You have forgotten one critical point: The writes to save the snapshot 
> image must be allowed.  That's what makes it really hard.

Well, I didn't forget about that, although my language may have been a
bit ambiguous.  I was referring only to the operations that are done by
normal (i.e. non-hibernate) portions of the system and which are not
explicitly for the purpose of hibernating the system.  It is very
difficult to maintain this guarantee while also attempting to reuse the
same infrastructure that is supposed to not be processing any "normal"
requests in order to write the snapshot.  The kdump approach handily
avoids this problem by *not* reusing the same infrastructure while still
allowing complete flexibility (i.e. not depending on a
drivers/suspend/ide-simple).

-- 
Jeremy Maitin-Shepard
