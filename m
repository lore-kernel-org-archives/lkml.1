Return-Path: <linux-kernel-owner+w=401wt.eu-S967639AbXG3VTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967639AbXG3VTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965031AbXG3VTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:19:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42031 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964959AbXG3VTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:19:11 -0400
Date: Mon, 30 Jul 2007 23:18:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@stusta.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] let SUSPEND select HOTPLUG_CPU
Message-ID: <20070730211826.GA22419@elf.ucw.cz>
References: <200707251238.50218.lenb@kernel.org> <200707262117.26353.rjw@sisk.pl> <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org> <200707262248.09187.rjw@sisk.pl> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org> <20070727222503.GB15129@stusta.de> <46AA7609.1040900@s5r6.in-berlin.de> <20070727230307.GC15129@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727230307.GC15129@stusta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Wait, doesn't HOTPLUG_CPU also depend on EXPERIMENTAL?
> 
> Damn, I started thinking about it, and then forgot about it when 
> finishing the patch.
> 
> My thoughts were:
> Is HOTPLUG_CPU still an experimental feature, or has it become a 
> well-tested no longer experimental feature now that it's used on
> most recent laptops?

It is complex :-(.

HOTPLUG_CPU is pretty solid for the case how _suspend_ uses it (ie
drivers quiescent).

It is also known broken for _other_ uses. (There was flamewar about
that recently).

I'm not sure how to express that in Kconfig language without
uglyness... We probably could split HOTPLUG_CPU into
HOTPLUG_CPU_SUSPEND_ONLY (not experimental) and HOTPLUG_CPU (enables
/sysfs interface)... but I do not think that is good idea. (It would
also make suspend debugging a bit harder).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
