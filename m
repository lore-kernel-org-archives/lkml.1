Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbXGIEVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbXGIEVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbXGIEVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:21:38 -0400
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:58431 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXGIEVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:21:37 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
In-Reply-To: <20070708120933.GA3866@ucw.cz> (Pavel Machek's message of "Sun\, 8
	Jul 2007 12\:09\:33 +0000")
References: <Pine.LNX.4.44L0.0707061039380.3737-100000@iolanthe.rowland.org>
	<200707080108.17371.rjw@sisk.pl> <20070708120933.GA3866@ucw.cz>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 09 Jul 2007 00:21:32 -0400
Message-ID: <87odimw6k3.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

[snip]

> I don't know how to do that mechanism... but if we knew where to trap
> filesystem writes, we could simply freeze at that point, and at that
> point only, no?

Any operation at all that has an external effect must not occur after
the snapshot is made; otherwise, there will be random hard-to-find
corruptions and other problems occurring as a result.  Thus, for
example, any writes (either directly or indirectly through e.g. a
filesystem) to non-volatile storage, any network traffic, any
communication with hardware like a printer must be prevented after the
snapshot.  It seems, though, that in general the kernel will have no way
to know which operations are safe, and which are not safe.

(This is why the whole "proper filesystem snapshot support is the
solution" argument is bogus.)

-- 
Jeremy Maitin-Shepard
