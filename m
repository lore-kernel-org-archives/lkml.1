Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXFLOu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXFLOu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXFLOuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:50:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2852 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752137AbXFLOuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:50:18 -0400
Date: Tue, 12 Jun 2007 14:50:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070612145007.GA5986@ucw.cz>
References: <200706071530.51552.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706071530.51552.jesse.barnes@intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On some machines, buggy BIOSes don't properly setup WB MTRRs to
> cover all available RAM, meaning the last few megs (or even gigs)
> of memory will be marked uncached.  Since Linux tends to allocate
> from high memory addresses first, this causes the machine to be
> unusably slow as soon as the kernel starts really using memory
> (i.e. right around init time).

> +	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
> +		printk(KERN_WARNING "***************\n");
> +		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
> +		printk(KERN_WARNING "**** MTRRs don't cover all of "
> +		       "memory, trimmed %ld pages\n", end_pfn -
> +		       (highest_addr >> PAGE_SHIFT));
> +		printk(KERN_WARNING "***************\n");
> +		end_pfn = highest_addr >> PAGE_SHIFT;

Missing 4K of memory is not worth 4K of junk in syslog per boot. Can
you drop the stars and stop shouting?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
