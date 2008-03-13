Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYCMKLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYCMKLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYCMKLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35230 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbYCMKLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:33 -0400
Date: Thu, 13 Mar 2008 08:46:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Hibernation: Fix mark_nosave_pages()
Message-ID: <20080313074621.GB19117@elf.ucw.cz>
References: <200803120034.58615.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803120034.58615.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-12 00:34:57, Rafael J. Wysocki wrote:
> Hi Len,
> 
> The following patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=9966 .
> 
> Although the problem has been there for quite some time (since before 2.6.22,
> apparently), it would be good to have in 2.6.25, because it may fix booting
> problems on the affected systems.
> 
> Please note that it doesn't modify the code behavior on the systems which are
> not affected by bug #9966 .
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> There is a problem in the hibernation code that triggers on some NUMA
> systems on which pfn_valid() returns 'true' for some PFNs that don't
> belong to any zone.  Namely, there is a BUG_ON() in
> memory_bm_find_bit() that triggers for PFNs not belonging to any
> zone and passing the pfn_valid() test.  On the affected systems it
> triggers when we mark PFNs reported by the platform as not saveable,
> because the PFNs in question belong to a region mapped directly using
> iorepam() (i.e. the ACPI data area) and they pass the pfn_valid()
> test.
> 
> Modify memory_bm_find_bit() so that it returns an error if given PFN
> doesn't belong to any zone instead of crashing the kernel and ignore
> the result returned by it in mark_nosave_pages(), while marking the
> "nosave" memory regions.
> 
> This doesn't affect the hibernation functionality, as we won't touch
> the PFNs in question anyway.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK. I hate how it adds more code to swsusp, but I could not find a
simple way to avoid that.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
