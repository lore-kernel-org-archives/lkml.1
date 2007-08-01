Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbXHAAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbXHAAso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXHAAsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:48:37 -0400
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:51303 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbXHAAsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:48:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=PrOQvs04d6QzHlB5tqSRKWED/SKRqkBDzxTookHZxkbm/iLvbQVaGmBMq41VsOGD;
  h=Received:Message-ID:Reply-To:From:To:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7d3d3$094c3d20$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: <linux-kernel@vger.kernel.org>
Subject: Re: Question: Scheduler 'Exit' or modularization of scheduler?
Date: Tue, 31 Jul 2007 17:29:34 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec7985127a26306950cc226f7f5e38cbc1cd350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.95.90
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Robinson,

        Solaris's SunOS SVR4.x has a modular schedular / dispatcher,
        however, I believe that the time share dispatcher is
        actually a frozen-base and is not replaceable. I do
        believe that some of its scheduling characteristics are
        modifyable.

        IT is my understanding that CFS is the new schedular,
        however it is separated from the RT (real-time) FIFO and
        RR schedular.

        Currently, I have a initial suggestion to lkma to see if
        their is any support of a interactive task class. It allows
        a root user to classify a set of tasks as interactive.
        If their is acceptance, I plan to propose a patch/ set of 
        changes to support this new task class by the end of Aug.

        IFF, then maybe in the future...
        Paul Robinson, if you feel that you are up to the task
        of modularizing the schedular / dispatcher to do what
        you think should be done, I would suggest submitting
        a prototype to Ingo, et al and see what the response
        is..


        Mitchell Erblich
        ----------------

Paul Robinson wrote:
> 
> There has been a considerable amount of talk and many news
articles on
> some websites because of the inclusion of the CFS scheduler either
as a
> replacement for the old scheduler or instead of using the SD
scheduler,
> some people apparently feel that one or the other of these is not
right
> in some contexts or in some environments.  I'm not completely
clear on
> what is going on or exactly what the complaint is.  But I
personally
> would like to try to toss in my 0.02 Euro in an attempt to offer
some
> light and less heat to the dilemma and offer a suggestion.
> 
> If my ignorance of the subject is too obvious, please excuse me, I
might
> not have that much experience in the subject.  I've only been
> programming for 27 years and I hope to get better at it with more
practice.
> 
> So, there are two questions about which I am wondering.   They may
be
> somewhat related but the methodology for each are different and
the
> method of implementation would be different.
> 
> 1. Could it be possible to design the interface to the scheduler
either
> that there is an 'exit' (my mainframe history precedes me) in
which one
> can issue a monitor call such that the system changes to an
alternate
> scheduler, possibly as part of the boot process?  Thus there might
be a
> default scheduler but it is possible to invoke an alternative one.
> 
> 2.  Could the scheduler be such that it be designed as a system
loadable
> module rather than as a monolithic part of the code, such that the
> particular scheduler is a specific file and is simply installed at
boot
> time, and if someone wants a different scheduler, they can simply
create
> a new one, rename the existing one to something else, name theirs
to
> whatever the scheduler's name is, then shutdown and reboot the
machine?
> 
> I am thinking that the system scheduler is an integral part of a
> time-shared operating system, it would be memory resident while
the
> machine is operating, thus it only has to be on disk during start
up and
> is not in use while the system is in normal operation and could be
> replaced at any time (subject to the usual caveat that the system
has to
> be shutdown and rebooted to cause the scheduling mechanism to be
changed
> to the new one.).
> 
> If such a capacity were available, or perhaps if such capacity can
be
> implemented at some point in the future, this would solve one of
the
> more critical issues, since people needing more finely tuned
scheduling
> facilities can use one different from the common one, or 'roll
their
> own' if they need something really special.
> 
> I am also thinking this sort of a capacity would be extremely
useful
> either in virtualization issues, in running other operating
systems (or
> copies of Linux) as guest operating systems under Linux vis-a-vis
Xen,
> or in respect to real-time versions of Linux, such that if someone
needs
> to grant certain processes high priority, and the rest everything
that's
> left over, then they could do that simply by writing the scheduler
to
> the interface definition.
> 
> Of course, I could be completely wrong on this point and this is
not a
> partitionable feature, that it's not possible to have the job
scheduler
> loaded from a secondary module at boot time.  (This may be one of
the
> reasons why there have been problems with non-monolithic kernels
being
> unavailable for general use except in extremely limited cases.)
> 
> Or I could be wrong in that this issue isn't that important and
most of
> the noise over the issue is a small and vocal minority complaining
about
> a marginal and unimportant issue.   Of course, this sort of
situation is
> probably the case with 90% of all traffic on usenet, newsgroups
and
> mailing lists, so what else is new?
> 
> Or, and this is the big one, that this feature already exists in
the
> Linux kernel and the method of scheduler invocation is already
> modularized for boot-time invokation of any chosen job scheduler.
I do
> not think is at this time the case, because if modular scheduling
> systems were currently possible, all the flamage over this issue
> wouldn't have occurred, because those who didn't like the CFS
scheduler
> in place of the old one or wanted the SD scheduler, could simply
> substitute it.
> 
> I would appreciate any comments on this because I do think that if
this
> capacity were available it would provide a number of significant
> features and would perhaps solve a number of problems.  (It may
very
> well add new problems! But, hey, thems the breaks, all technology
> (usually) has benefits and (almost always has) drawbacks.)
> 
> --
> Paul Robinson - paul@paul-robinson.us  - "A computer programmer
and
> Notary Public in and for the Commonwealth of Virginia, at Large."
> "Above all else... We shall go on..." _"...And continue!"_
> "The lessons of history teach us - if they teach us anything -
that
> nobody learns the lessons that history teaches us."
> 
> -
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

