Return-Path: <linux-kernel-owner+w=401wt.eu-S1761811AbYCSVjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761811AbYCSVjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbYCSUJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:09:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42006 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764020AbYCSUJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:09:06 -0400
Date: Wed, 19 Mar 2008 12:49:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation	patchset against -rc6)
Message-ID: <20080319114924.GC21270@atrey.karlin.mff.cuni.cz>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318232037.GA1670@elf.ucw.cz> <47E05408.7000003@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E05408.7000003@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pavel Machek wrote:
> >On Tue 2008-03-18 10:31:28, Linus Torvalds wrote:
> >>
> >>On Tue, 18 Mar 2008, Pavel Machek wrote:
> >>>On Tue 2008-03-18 14:06:42, Pavel Machek wrote:
> >>>>Confirmed, suspend slowness is in 2.6.25-rc6, too. It takes 15 seconds
> >>>>to suspend/resume, while 2.6.24 takes 9. Thinkpad x60.
> >>>IIRC 2.6.25-rc5 was "fast".
> >>Can you bisect it? There's only 343 commits between -rc5 and -rc6, so it 
> >>should not take too long to check which commit it is. Even if it should 
> >>take 9 reboots to bisect it entirely, going just five or six will likely 
> >>narrow it down sufficiently that we can probably guess fairly well what 
> >>it's about.
> >
> >Slowdown is fixed by this patch:
> I think only this part is relevant here. But yes, I agree that the whole 
> patch should be reverted.
> >@@ -230,7 +227,6 @@ static int acpi_ec_wait(struct acpi_ec *
> > 		while (time_before(jiffies, delay)) {
> > 			if (acpi_ec_check_status(ec, event))
> > 				goto end;
> >-			msleep(5);
> > 		}
> > 	}
> > 	pr_err(PREFIX "acpi_ec_wait timeout,"
> Thanks,
> Alex.

> ACPI: EC: Revert storm handler patch
> 
> From: Alexey Starikovskiy <astarikovskiy@suse.de>
> 
> Patch have caused several new troubles, so just revert it for now.
> 
> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>

Tested-by: Pavel Machek <pavel@suse.cz>
ACK.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
