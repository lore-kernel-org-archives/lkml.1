Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbXJLBsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbXJLBsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 21:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXJLBsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 21:48:13 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35753 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753928AbXJLBsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 21:48:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YnezTA0MgaSMySqGp8zJlMGaEQR4Rlyt0WLrE1yRdmLNC8LYvA9lTTlWFItCCcLmKYbX/kzrgsC40tuhRwx/sUNtysI7xFKS62qSK2+aTSWd234u6uyF7cOqqOQ5lQm1adrdc01cyF5LJFDzPeq+f9M1OB8ElMrjwbAnwxWHJ/I=  ;
X-YMail-OSG: spkVrb8VM1n7Od.2DwDJzFOM4goaoQcOKV4BIJuVKIgjNME6sAMg1ksPz6bTbQBlD.l.hZHlOIZZo.1N4Zbmx.xiPNoUyQXQT.t6t16DOISQ.4M5S1gmCnJQeTnXng--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.23
Date: Thu, 11 Oct 2007 19:16:23 +1000
User-Agent: KMail/1.9.5
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org> <1191996740.8694.7.camel@entropy> <20071010101452.GA25433@elte.hu>
In-Reply-To: <20071010101452.GA25433@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710111916.23633.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2007 20:14, Ingo Molnar wrote:
> * Nicholas Miell <nmiell@comcast.net> wrote:
> > Does CFS still generate the following sysbench graphs with 2.6.23, or
> > did that get fixed?
> >
> > http://people.freebsd.org/~kris/scaling/linux-pgsql.png
> > http://people.freebsd.org/~kris/scaling/linux-mysql.png
>
> as far as my testsystem goes, v2.6.23 beats v2.6.22.9 in sysbench:
>
>     http://redhat.com/~mingo/misc/sysbench.jpg
>
> As you can see it in the graph, v2.6.23 schedules much more consistently
> too. [ v2.6.22 has a small (but potentially statistically insignificant)
> edge at 4-6 clients, and CFS has a slightly better peak (which is
> statistically insignificant). ]
>
> ( Config is at http://redhat.com/~mingo/misc/config, system is Core2Duo
>   1.83 GHz, mysql-5.0.45, glibc-2.6. Nothing fancy either in the config
>   nor in the setup - everything is pretty close to the defaults. )
>
> i'm aware of a 2.6.21 vs. 2.6.23 sysbench regression report, and it
> apparently got resolved after various changes to the test environment:
>
>    http://jeffr-tech.livejournal.com/10103.html
>
>  " [<CFS>] has virtually no dropoff and performs better under load than
>    the default 2.6.21 scheduler. " (paraphrased)

;) I think you snipped the important bit:

"the peak is terrible but it has virtually no dropoff and performs
better under load than the default 2.6.21 scheduler." (verbatim)

The dropoff under load was due to trivially avoided mmap_sem
contention in the kernel and glibc (and not-very-scalable mysql
heap locking), rather than specifically anything the scheduler
was doing wrong, I think (when the scheduler chose to start
preempting threads holding locks, then performance would tank.
Exactly when that point was reached, and what happens afterwards
was probably just luck.)
