Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbXGHWNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbXGHWNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 18:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbXGHWN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 18:13:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33479 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757309AbXGHWNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 18:13:25 -0400
Date: Mon, 9 Jul 2007 00:13:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: hibernation/snapshot design [was Re: [PATCH] Remove process freezer from suspend to RAM pathway]
Message-ID: <20070708221315.GF5401@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org> <200707082115.27363.rjw@sisk.pl> <1183928612.3388.289.camel@localhost.localdomain> <200707082345.27859.rjw@sisk.pl> <1183931688.3388.316.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183931688.3388.316.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Actaully, I'm perfectly fine with that, as long as each task blocked by the
> > driver due to suspend has PF_FROZEN (or something similar) set.  Then, at
> > least theoretically, we'll be able to drop the freezer from the suspend code
> > path and move it after device_suspend() (or the hibernation-specific
> > equivalent) for hibernation (in that case there shouldn't be a problem with
> > any task waiting on I/O while the freezer is running ;-)).
> 
> I don't see the need for a freezer for snapshot but that's a different
> issue. (stop_machine looks good enough to me).

Freezer is not needed for snapshot -- it is needed so that we can
write out the snapshot to disk without the need for special
drivers/block/simple-ide-for-suspend.c. (We are doing snapshot, then
write to disk from userland code in uswsusp).
								Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
