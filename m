Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbXGFD7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbXGFD7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 23:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758664AbXGFD7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 23:59:06 -0400
Received: from alnrmhc15.comcast.net ([206.18.177.55]:53797 "EHLO
	alnrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546AbXGFD7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 23:59:05 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, oliver@neukum.org, pavel@ucw.cz,
       paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com>
	<20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu>
	<200707052138.56920.oliver@neukum.org>
	<E1I6XFM-0001ek-00@dorka.pomaz.szeredi.hu>
	<1183676751.3388.96.camel@localhost.localdomain>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Thu, 05 Jul 2007 23:59:00 -0400
In-Reply-To: <1183676751.3388.96.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Fri\, 06 Jul 2007 09\:05\:51 +1000")
Message-ID: <87d4z6xjwb.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

[snip]

> At the end of the day, I stand my ground, the freezer cannot be made
> reliable without massive infrastructure changes or giving up on very
> useful features such as fuse among others. Besides, it only partially
> "hides" the problem of requests going to drivers, thus it's a bad
> solutions.

I agree that the freezer absolutely should not be used for suspend to
ram ("suspend"), since it is unnecessary with properly written drivers,
which are important to have anyway.  It seems that it is indeed the
consensus that it will be phased out sooner or later.

It does seem that the current device suspend interface does not tell the
drivers enough, since as discussed, they need to know whether to merely
block if they receive a request while suspended (as should be done while
initiating a suspend to ram), or if they should wake up the device (as
should be done if a suspend to ram is not in progress).  Clearly these
two cases need to be addressed by every driver supporting suspend/resume
(but possibly indirectly if the subsystem handles it for them).

The current hibernate approach used by all of the existing
implementations for Linux seems to depend fundamentally on the freezer,
though, in order to actually save the system state.  Thus, it will still
be necessary to fix all of the issues with the freezer, or adopt an
alternate hibernate approach (which is unlikely).  Unfortunately, even
leaving kernel threads and certain drivers running after the snapshot is
taken means that the saved image isn't completely correct, and the
freezer cannot help with these issues.

[snip]

-- 
Jeremy Maitin-Shepard
