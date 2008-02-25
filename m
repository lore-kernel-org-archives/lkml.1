Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbYBYVyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbYBYVyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYBYVy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:54:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53334 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752963AbYBYVy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:54:27 -0500
Date: Mon, 25 Feb 2008 22:54:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, acme@redhat.com,
       gregkh@suse.de, sdietrich@novell.com, pmorreale@novell.com,
       mkohari@novell.com
Subject: Re: [(RT RFC) PATCH v2 3/9] rearrange rt_spin_lock sleep
Message-ID: <20080225215454.GF2659@elf.ucw.cz>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net> <20080225160053.11268.60719.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225160053.11268.60719.stgit@novell1.haskins.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -720,7 +728,8 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
>  	 * saved_state accordingly. If we did not get a real wakeup
>  	 * then we return with the saved state.
>  	 */
> -	saved_state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
> +	saved_state = current->state;
> +	smp_mb();
>  
>  	for (;;) {
>  		unsigned long saved_flags;

Please document what the barrier is good for.

Plus, you are replacing atomic operation with nonatomic; is that ok?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
