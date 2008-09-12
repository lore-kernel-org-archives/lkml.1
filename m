Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYILTwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYILTwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbYILTwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:52:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4856 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752922AbYILTwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:52:35 -0400
Date: Fri, 12 Sep 2008 21:50:54 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Message-ID: <20080912195054.GB6028@ucw.cz>
References: <20080902349.573187695@firstfloor.org> <20080902134923.9A7EF3E6A01@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902134923.9A7EF3E6A01@basil.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> panic calls smp_send_stop which eventually calls smp_call_function_*.
> smp_call_function warns about disabled interrupts. But it's legal
> to call panic in this case. When this happens panic() prints
> several ugly backtraces. So don't check for disabled interrupts
> in panic state.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
...

>  	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> +	WARN_ON(system_state < SYSTEM_PANIC && irqs_disabled());

Nice trap if someone adds state after panic... replace < with !=?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
