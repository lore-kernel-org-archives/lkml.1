Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbYBVSCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbYBVSCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbYBVSCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:02:07 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:35343 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774AbYBVSCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:02:04 -0500
Date: Fri, 22 Feb 2008 18:01:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Message-ID: <20080222180132.GA32623@srcf.ucam.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211302.27002.jesse.barnes@intel.com> <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com> <200802211623.55450.jesse.barnes@intel.com> <b6a2187b0802211642i17730ccav6744b614c086df72@mail.gmail.com> <20080222103727.GA25781@srcf.ucam.org> <20080222130615.GA29123@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222130615.GA29123@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 02:06:15PM +0100, Ingo Molnar wrote:

> btw., why isnt there an in-kernel whitelist, with perhaps a dynamic, 
> convenient /debug/s2r/whitelist append-API for distros (and testers) to 
> add more entries to the whitelist/blacklist? (for cases where the kernel 
> whitelist has not caught up yet) Which would eventually converge to 
> Utopia: s2ram that just works out of box.

Because all of these video quirks are just workarounds for the fact that 
the kernel doesn't work properly. In general, you really don't want to 
call a real-mode video bios from the kernel, so punting it to userspace 
(and leaving the whitelisting there) is somewhat more straightforward. 
In addition, we can then extend the whitelist without requiring kernel 
upgrades.

> ( Sorry about the strong words, while there's lots of good and positive
>   development lately i havent seen much change in this particular area
>   of s2ram in the past 1-2 years, and the whole chain is only as strong
>   as the weakest link - so someone finally has to deliver this message
>   to the cozy fire of s2r hackers while our testers and users are 
>   standing out in the cold rain ... )

We've got i915 suspend/resume now, which already fixes this for a large 
number of users. Recent ATI is easy, now that we actually have specs for 
ATOM. The nouveau guys are almost at the point where we can do it for 
nvidia. That basically just leaves VIA.

The other s2r issues are pretty much just driver bugs at this point.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
