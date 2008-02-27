Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYB0OJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYB0OJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 09:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYB0OJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 09:09:37 -0500
Received: from ozlabs.org ([203.10.76.45]:59403 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYB0OJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:09:37 -0500
Date: Wed, 27 Feb 2008 08:05:04 -0600
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>,
       John Levon <levon@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080227140504.GA1435@kryten>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu> <20080223135335.GA28464@totally.trollied.org.uk> <ye8ejb3e8ef.fsf@camel10.daimi.au.dk> <20080226051307.GC17772@kryten> <20080226090223.GG9857@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226090223.GG9857@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Ingo,

> > Anton - who has used oprofile to analyse and tune databases, JVMs,
> > 	compilers and operating systems. Maybe I've been missing out on
> > 	the killer app for all this time!!!
> 
> it's OK if you use it full time and if you are amongst the 0.001% of the 
> developer population we call "the best kernel hackers on the planet" ;-) 

I dream of being a card carrying member of the club but apparently
owning the t-shirt doesn't count :)

> It sucks badly if you use it occasionally and have to re-learn its 
> non-trivial usage and its quirks every time. As it happens, most 
> userspace developers are in this second category.
>
> (and i'm not worried about the first category at all - if needed they 
> can write their own OS from scratch ;-)

Or their own profiling infrastructure!

OK I'm done being a pain, time to be constructive. It's becoming clear
we have some work to do in order to make oprofile easier to use. I've
been involved with the project from the early days, and it's hard to be
objective when it comes to usability issues.

Off the top of my head, there are a number of reasons I think it makes
sense to use the existing oprofile kernel code instead of adding the
sysprof kernel module:

- Wide architecture support. A quick look shows 9 architectures with
  oprofile kernel module code.

- biarch support. You can mix 32 or 64bit userspace and the same oprofile
  userspace works with 32 or 64bit kernels. I'm not sure where sysprof
  sits wrt this.

- Java and Mono support. Oprofile has work underway to communicate with
  a running JVM and produce symbolic debugging information:

http://primates.ximian.com/~massi/blog/archive/2007/Nov-19.html

- Robust sample to binary mapping. It appears that sysprof has a race
  where processes can exit before the user process has a chance to do
  the PID to binary mapping.

- Support for the full set of performance monitor events. A 100 or 250Hz
  timer is useful for simple profiling, but eventually you will want
  either faster sampling or different event sampling (eg cache misses).

Oprofile now has a mode to output XML and it shouldn't take much effort
for sysprof to parse this instead of the binary debugfs file.

Anton
