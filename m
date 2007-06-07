Return-Path: <linux-kernel-owner+w=401wt.eu-S938165AbXFHPLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938165AbXFHPLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761049AbXFHPKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:10:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2712 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760162AbXFHPKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:10:52 -0400
Date: Thu, 7 Jun 2007 14:41:02 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070607144102.GC9094@ucw.cz>
References: <200706061229.24486.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706061229.24486.jesse.barnes@intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch works around the problem by scanning the MTRRs at
> boot and figuring out whether the current end_pfn value (setup
> by early e820 code) goes beyond the highest WB MTRR range, and
> if so, trimming it to match.  A fairly obnoxious KERN_WARNING
> is printed too, letting the user know that not all of their
> memory is available due to a likely BIOS bug.

Way too obnoxious warning, I'd say. Just drop the *s.

> +	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
> +		printk(KERN_WARNING "***************\n");
> +		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
> +		printk(KERN_WARNING "**** MTRRs don't cover all of "
> +		       "memory, trimmed %ld pages\n", end_pfn -
> +		       (highest_addr >> PAGE_SHIFT));
> +		printk(KERN_WARNING "***************\n");
> +		end_pfn = highest_addr >> PAGE_SHIFT;

...and I'd print lost memory in kilobytes, to be more luser-friendly.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
