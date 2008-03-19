Return-Path: <linux-kernel-owner+w=401wt.eu-S933035AbYCSVik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbYCSVik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762344AbYCSUJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:09:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41983 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760606AbYCSUJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:09:06 -0400
Date: Wed, 19 Mar 2008 12:48:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation patchset against -rc6)
Message-ID: <20080319114851.GB21270@atrey.karlin.mff.cuni.cz>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318225201.GA2115@elf.ucw.cz> <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > commit 7c0ea45be4f114d85ee35caeead8e1660699c46f
> > 
> >     ACPI: Ignore _BQC object when registering backlight device
> > 
> > when did this go in? Pretty recently, right?
> 
> Yes:
> 
> 	[torvalds@woody linux]$ git describe 7c0ea45be4f114d85ee35caeead8e1660699c46f
> 	v2.6.25-rc5-89-g7c0ea45
> 
> so it happened after -rc5.
> 
> > And that means that ACPI backlight driver is now used on machines where 
> > it was not used before...?
> 
> Somebody more into ACPI needs to judge how likely this is to be an issue..

Ok, 7c0... is innocent. Reverting not only the mdelay, but also rest
of drivers/acpi/ec.c patch fixed the
"rc6-breaks-backlight-in-X-over-lid-close", good.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
