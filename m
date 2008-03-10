Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbYCJQo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbYCJQo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYCJQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:44:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1342 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751034AbYCJQoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:44:17 -0400
Date: Mon, 10 Mar 2008 17:44:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] time(r) fixes for .25
Message-ID: <20080310164407.GC5040@ucw.cz>
References: <alpine.LFD.1.00.0803090857480.3099@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803090857480.3099@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> @@ -174,6 +174,10 @@ static inline void timespec_add_ns(struct timespec *a, u64 ns)
>  {
>  	ns += a->tv_nsec;
>  	while(unlikely(ns >= NSEC_PER_SEC)) {
> +		/* The following asm() prevents the compiler from
> +		 * optimising this loop into a modulo operation.  */
> +		asm("" : "+r"(ns));
> +

optimizing -> pessimizing or "optimizing" or explain that "optimized"
version is slower than real version?

Missing space between while and ( ?

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
