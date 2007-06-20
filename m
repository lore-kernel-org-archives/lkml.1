Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbXFTUcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbXFTUcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXFTUcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:32:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4226 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752841AbXFTUcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:32:19 -0400
Date: Wed, 20 Jun 2007 20:16:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, torvalds@linux-foundation.org
Subject: Re: [PATCH] blink: Only blink when parameter is set
Message-ID: <20070620201637.GA5610@ucw.cz>
References: <20070617083904.GC4496@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617083904.GC4496@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch in the blink driver changes the module to only blink when
> the parameter 'blink' is set to true. This is to allow the module to
> be compiled in the kernel and not as module.
> 
> As the blink module was initially written for kdump, and as the kernel
> is relocatable on lots of architectures, there's no need to compile a
> separate kdump kernel. The blinking can now enabled via the boot
> command line for the kdump kernel when necessary.
> 
> The patch also adds some author/license information and marks the init
> function as '__init'.
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>

Patch looks good (and needed!) to me, but:

can we remove that driver, instead? 

* It breaks keyboards. Yes, we are
talking about maybe-broken i8042s, but it still breaks thinkpads at
least.

* It can be done in userspace. setleds +num; sleep 1; setleds -num <
/dev/tty1 does not seem like rocket science to me.

* if we want to do this, perhaps we should use proper led interface
(/sys/class/led) that can already auto-blink

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
