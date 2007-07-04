Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbXGDXeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbXGDXeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbXGDXdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:33:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45649 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755258AbXGDXdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:33:54 -0400
Date: Thu, 5 Jul 2007 01:33:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070704233351.GA2719@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703042916.GA17240@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> a screaming nightmare - either the suspend fails because syslog (for 
> instance) can't be frozen, or the machine deadlocks for some other 
> reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> could do what we do for suspend to RAM on other platforms (PPC and APM) 
> and just not use the freezer.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

Sorry, no.

* this needs audit of all drivers. Or we can just merge it and then
fix all the problems it causes. If you are willing to become suspend
maintainer and handle all that mess, perhaps we can do this.

* it does not solve FUSE vs. hibernation

* it does not solve FUSE vs. suspend-to-both

* userspace will now see CPUs going up and down at minimum

Now, we want to do something like this long-term, but I do not think
we can just remove the freezer like this.


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
