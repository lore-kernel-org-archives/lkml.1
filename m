Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYFELQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYFELQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 07:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYFELQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 07:16:16 -0400
Received: from web26206.mail.ukl.yahoo.com ([217.12.10.243]:48836 "HELO
	web26206.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753914AbYFELQP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 07:16:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=iGSd7AfoBuP29b8GkEvZLTMErJkMqX67BRFsee3KWlPievbDBryXGKTQHjwQwVTwYRb5Z4/PeAde4Qzysd6D/W0sl9A/WAeSJbyjThX9tpsHgAPrin49XeI4ESHVZQjTtuI2sHNR1AlgIpNjZlS3XQn3jDij1WHVVAyNNKyRSoM=;
X-Mailer: YahooMailWebService/0.7.199
Date: Thu, 5 Jun 2008 11:16:13 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Reply-To: trimarchimichael@yahoo.it
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Max Krasnyansky <maxk@qualcomm.com>, Mark Hounschell <dmarkh@cfl.rr.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Oeser <ioe-lkml@rameria.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dario <faggioli@gandalf.sssup.it>
In-Reply-To: <1212616348.19205.29.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <933603.75777.qm@web26206.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > 
> > I'm working on a partitioned EDF scheduler right
> now, and I have to
> > face several issues, starting from the interface to
> use to expose the
> > EDF scheduler to userspace, and the integration with
> the existing
> > sched_rt policy.
>
> I would add a sched_class above sched_rt and let sched_rt
> run in all
> unclaimed time by sched_edf.
>
I add this type of class before sched_rt, so the next of sched_edf
point to sched_rt class.

> Have you looked at deadline inheritance to replace PI? I
> think it can be
> done reasonably simple by replacing the plist with a RB
> tree.
I think it can be done with an rb tree.  The only tricky 
part would be mixing tasks coming from  the sched_edf and the sched_rt class, but it should not be a problem.
>
> > By now I'm experimenting with an additional
> sched_class that implements
> > a SCHED_EDF policy, extending the POSIX struct
> sched_param with the
> > EDF parameters of the task, do you see any better way
> to do that?
> > Could that approach be reasonable?
>
> Yes, that is the way I'm leaning.
By now I'm facing some problems.  I still have not clear what parameters a task forked from a sched_edf task should get, as it would involve some form of admission control, and how to deal with tasks that run longer than their nominal execution time (i.e., should we use some server mechanism to limit the amount of cpu they're using, or handle that in some other way?)

Michael


      ___________________________________ 
Scopri il Blog di Yahoo! Mail: trucchi, novità, consigli... e la tua opinione!
http://www.ymailblogit.com/blog/
