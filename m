Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZBPW6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZBPW6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZBPW6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:58:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50863 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZBPW6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:58:44 -0500
Date: Mon, 16 Feb 2009 23:58:31 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216225831.GH1370@ucw.cz>
References: <200902160010.16955.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902160010.16955.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The recent descussion about the Android PM patches sent by Arve shows that
> there is a need to introduce a mechanism allowing us to:
> (1) automatically put the system as a whole into a sleep state (eg. suspend to
>     RAM) when it is found to be "idle", where the meaning of "idle" has to be
>     defined too,

Well; I'd prefer to keep the interface very minimal.

If no devices are being used, and next wakeup is far enough in the
future, just put system to sleep. Long enough == so far away that
suspend/wakeup is short compared to that... like 20 seconds on PC.

Ok, it probably needs to be opt-in: echo auto-mem > /sys/power/state
should do the trick.

This will need either fixing all the applications not to poll, or
maybe someone SIGSTOP-ing apps that are in background and poll too
often.

> (2) put given subset of devices into low power states whenever they are not
>     used, without putting the entire system into a sleep state.

Arjan said this nicely...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
