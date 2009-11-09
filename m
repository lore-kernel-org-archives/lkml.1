Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbZKIAKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbZKIAKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 19:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZKIAKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 19:10:20 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44152 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZKIAKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 19:10:19 -0500
Date: Sun, 8 Nov 2009 19:10:03 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091109001003.GA4129@localhost.localdomain>
References: <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF3F3CF.5080503@gmail.com> <20091108103629.GA11372@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108103629.GA11372@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.8 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 11:36:29AM +0100, Ingo Molnar wrote:
> 
> * Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > On 11/06/2009 10:26 AM, Ingo Molnar wrote:
> > > Jiri, i think your patches are incomplete for the same reasons i 
> > > outlined to Neil.
> > 
> > I'll examine that. Thanks for pointing out.
> > 
> > > Also, the locking there looks messy:
> > > 
> > > +       /* optimization: 'current' doesn't need locking, e.g. setrlimit */
> > > +       if (tsk != current) {
> > > +               /* protect tsk->signal and tsk->sighand from disappearing */
> > > +               read_lock(&tasklist_lock);
> > > +               if (!tsk->sighand) {
> > > +                       retval = -ESRCH;
> > > +                       goto out;
> > > +               }
> > >         }
> > > 
> > > Neil's splitup into a helper function looks _far_ cleaner.
> > 
> > Then, I think, we should join our efforts.
> 
> i think your commits could be enhanced to include Neil's splitup (and 
> keeping your write extension for /proc/*/limits), and the new syscall 
> (with a security check), hm?
> 
> Without dropping your current commits - they already have testing value.
> 
That seems like a reasonable approach to me.  Jiri, would you like to do that or
shall I?  I'm happy to but it will take me a few days (I've got a bug I need to
focus on first).

Regards
Neil

