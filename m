Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZKHKhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZKHKhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZKHKhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:37:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35208 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbZKHKhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:37:09 -0500
Date: Sun, 8 Nov 2009 11:36:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
 external to a process (v7)
Message-ID: <20091108103629.GA11372@elte.hu>
References: <20091012201304.GG32088@hmsreliant.think-freely.org>
 <20091020005214.GA8886@localhost.localdomain>
 <20091102152520.GG23776@elte.hu>
 <20091102175407.GE4075@hmsreliant.think-freely.org>
 <20091102185137.GA28803@elte.hu>
 <20091103002355.GB19891@localhost.localdomain>
 <20091104112632.GA9243@elte.hu>
 <20091105204843.GA2980@hmsreliant.think-freely.org>
 <20091106092600.GC22505@elte.hu>
 <4AF3F3CF.5080503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF3F3CF.5080503@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 11/06/2009 10:26 AM, Ingo Molnar wrote:
> > Jiri, i think your patches are incomplete for the same reasons i 
> > outlined to Neil.
> 
> I'll examine that. Thanks for pointing out.
> 
> > Also, the locking there looks messy:
> > 
> > +       /* optimization: 'current' doesn't need locking, e.g. setrlimit */
> > +       if (tsk != current) {
> > +               /* protect tsk->signal and tsk->sighand from disappearing */
> > +               read_lock(&tasklist_lock);
> > +               if (!tsk->sighand) {
> > +                       retval = -ESRCH;
> > +                       goto out;
> > +               }
> >         }
> > 
> > Neil's splitup into a helper function looks _far_ cleaner.
> 
> Then, I think, we should join our efforts.

i think your commits could be enhanced to include Neil's splitup (and 
keeping your write extension for /proc/*/limits), and the new syscall 
(with a security check), hm?

Without dropping your current commits - they already have testing value.

> > I'm also wondering, how did these commits get into linux-next? It 
> > appears that that the 'writable_limits' tree got added by sfr to 
> > linux-next on Oct 26 just based on Jiri's request, without 
> > acks/review from the people generally involved with this code.
> 
> I posted the patches three times. The first, we discussed with Oleg 
> Nesterov the whole thing (with you in CC btw) and I resent changed 
> code (v2) based on Oleg's input. Then, after a month and a half I 
> reposted whole patchset simply because nobody cared/commented. Waited 
> another 10 days and got pissed off (that I'm ignored for no obvious 
> reason) so that I asked Stephen (publicly) to include it in the -next. 
> He did, I wouldn't say it's all his fault. I must add that selinux 
> security guys cooperated with me on the first patches.
> 
> I hoped for anybody's raised voice: nobody's :(. Is there anything I 
> did wrong? Who are the people to get an ACK from in this case?

Nah, it's just me grumbling about the sieve that our review process is 
;-) This command could be useful in the future for constructing Cc: 
lines:

  scripts/get_maintainer.pl -f kernel/sys.c

that's all.

	Ingo
