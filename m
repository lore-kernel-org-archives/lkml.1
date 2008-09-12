Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYILC6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYILC6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 22:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbYILC6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 22:58:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951AbYILC6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 22:58:07 -0400
Date: Thu, 11 Sep 2008 19:57:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: j_kernel@hoblitt.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
 tick_periodic() ???
Message-Id: <20080911195708.f975e9b6.akpm@linux-foundation.org>
In-Reply-To: <20080912025458.GF27054@hoblitt.com>
References: <bug-11543-10286@http.bugzilla.kernel.org/>
	<20080911170258.aa0bea0d.akpm@linux-foundation.org>
	<20080912025458.GF27054@hoblitt.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 16:54:58 -1000 j_kernel@hoblitt.com wrote:

> > The panic code called the kexec code which called mutex_trylock() which
> > called spin_lock_mutex() which then stupidly went and blurted a load of
> > debug stuff because of in_interrupt().
> > 
> > Something like this:
> > 
> > --- a/include/linux/debug_locks.h~a
> > +++ a/include/linux/debug_locks.h
> > @@ -17,7 +17,7 @@ extern int debug_locks_off(void);
> >  ({									\
> >  	int __ret = 0;							\
> >  									\
> > -	if (unlikely(c)) {						\
> > +	if (!oops_in_progress && unlikely(c)) {				\
> >  		if (debug_locks_off() && !debug_locks_silent)		\
> >  			WARN_ON(1);					\
> >  		__ret = 1;						\
> > _
> > 
> > might prevent the debugging code from preventing us from finding bugs :(
> 
> Do you want me to give that patch a try or sit tight for a bit?

It's be good if you can try it please, see if we can get a cleaner
trace.
