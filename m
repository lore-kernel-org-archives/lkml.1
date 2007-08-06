Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbXHFJH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbXHFJH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbXHFJHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:07:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59767 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbXHFJHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:07:14 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 05:07:14 EDT
Date: Mon, 6 Aug 2007 11:07:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>,
       Andi Kleen <ak@suse.de>
Subject: Re: [Resend][PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION (updated)
Message-ID: <20070806090713.GC15329@atrey.karlin.mff.cuni.cz>
References: <200708051906.22865.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708051906.22865.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +config SUSPEND_UP_POSSIBLE
> +	bool
> +	depends on (X86 && !X86_VOYAGER) || (PPC32 && PPC_MPC52xx) \
> +		   || (PPC64 && (PPC_PSERIES || PPC_PMAC)) || ARM || BLACKFIN \
> +		   || MIPS || SUPERH || FRV
> +	depends on !SMP
> +	default y

I guess I'd rather left SUSPEND_UP_POSSIBLE to allways y (as it always
was), and let architectures that can't handle it  not return "mem"
from list of valid states...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
