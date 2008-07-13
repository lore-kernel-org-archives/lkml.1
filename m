Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbYGMIz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbYGMIz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 04:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYGMIzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 04:55:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37693 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYGMIzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 04:55:19 -0400
Date: Sun, 13 Jul 2008 10:56:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andy Lutomirski <luto@myrealbox.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080713085603.GB6890@elf.ucw.cz>
References: <200807010148.02135.rjw@sisk.pl> <200807122253.32382.rjw@sisk.pl> <48793A0E.3050803@myrealbox.com> <200807130133.12324.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807130133.12324.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Is there an Intel graphics in your box?
> > 
> > Yes.
> > 
> > > 
> > >> -rc8 and -rc9 with the original patch 4b4f7280 resume fine no matter how 
> > >> I suspend.
> > > 
> > > That's _really_ strange.
> > > 
> > > In fact I have only one explanation, which is that the Gnome suspend button
> > > causes some user-space quirks to be applied, which are harmful and break the
> > > resume.  Also, without commit 4b4f7280 those quirks might have not been really
> > > executed.  Peter, does it sound reasonable?
> > 
> > Bingo.  It's a HAL quirk.
> > 
> > Testing from the console (not X):
> > 
> > With 4b4f7280:
> > # echo mem >/sys/power/state -- works fine
> > 
> > # echo 3 >/proc/sys/kernel/acpi_video_flags
> > # echo mem >/sys/power state -- fails to resume
> > 
> > Without 4b4f7280:
> > # echo mem >/sys/power/state -- works fine
> > 
> > # echo 3 >/proc/sys/kernel/acpi_video_flags
> > # echo mem >/sys/power state -- works fine
> > 
> > So HAL contains an apparently unnecessary quirk for my laptop, and 
> > 4b4f7280 breaks that quirk.  Of course, it's entirely possible that 
> > 4b4f7280 is 100% correct, but that the quirk only worked by accident and 
> > 4b4f7280 broke the call into video BIOS.
> 
> We've had reports from users of Intel graphics and the i915 driver that
> previously working quirks started to break their systems with 2.6.26-rc, but
> instead the plain "echo mem > /sys/power/state" started to work for them.
> Your system may be one of these, but I wonder what the effect of commit
> 4b4f7280 is.

In such case, you could verify by disabling intel framebuffer and just
using plain VGA driver (or vesafb).

Breaking video bios calls would be bad.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
