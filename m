Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbYCSVNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbYCSVNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761924AbYCST7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36148 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761895AbYCST7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:30 -0400
Date: Wed, 19 Mar 2008 00:05:38 +0100
From: Pavel Machek <pavel@suse.cz>
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
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation
	patchset against -rc6)
Message-ID: <20080318230538.GA1686@elf.ucw.cz>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318225201.GA2115@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318225201.GA2115@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > should not take too long to check which commit it is. Even if it should 
> > take 9 reboots to bisect it entirely, going just five or six will likely 
> > narrow it down sufficiently that we can probably guess fairly well what 
> > it's about.
> 
> Hmm, it gets weirder. 2.6.25-rc5 was fast, and had small problem with
> backlight hotkeys did not work.
> 
> 2.6.25-rc6 has backlight hotkeys somehow working, but closing/opening lid in X
> kills the backlight, making machine unusable.
> 
> Hmm...
> 
> commit 7c0ea45be4f114d85ee35caeead8e1660699c46f
> tree 0822ef23606a733e00bbf75d3e218b1e92abdd78
> parent 2f44bbb495dd3e6d0209eff2257438ab9c570e5b
> author Zhao Yakui <yakui.zhao@intel.com> Tue, 11 Mar 2008 16:56:47
> +0800
> committer Len Brown <len.brown@intel.com> Tue, 11 Mar 2008 22:20:19
> -0400
> 
>     ACPI: Ignore _BQC object when registering backlight device
> 
>     According to acpi spec , the objects of  _BCL and _BCM are
> required if
>     integrated LCD is present and supports brightness level .The _BQC
> is
>     the optional object. So the _BQC object is ignored when the
> backlight device
>     is registered in ACPI video driver.
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=10206
> 
>     Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>     Signed-off-by: Zhang Rui  <rui.zhang@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> 
> when did this go in? Pretty recently, right? And that means that ACPI
> backlight driver is now used on machines where it was not used
> before...?

No, this commit was not responsible, but CONFIG_ACPI_VIDEO *is*
responsible for the "X has no backlight after lid close/open".
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
