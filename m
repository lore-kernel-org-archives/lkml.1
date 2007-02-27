Return-Path: <linux-kernel-owner+w=401wt.eu-S1751455AbXB0IOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbXB0IOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbXB0IOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:14:38 -0500
Received: from smtp.ono.com ([62.42.230.12]:44824 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751455AbXB0IOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:14:37 -0500
Date: Tue, 27 Feb 2007 09:14:09 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Rik van Riel <riel@redhat.com>
Cc: Hiro Yoshioka <hyoshiok@miraclelinux.com>, davej@redhat.com,
       harlan@artselect.com, nickpiggin@yahoo.com.au, l_allegrucci@yahoo.it,
       linux-kernel@vger.kernel.org, mingo@elte.hu, suparna@in.ibm.com,
       jens.axboe@oracle.com
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070227091409.6f3d12f9@werewolf-wl>
In-Reply-To: <45E3B421.603@redhat.com>
References: <20070226223645.GA24174@redhat.com>
	<98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>
	<45E37EA3.3060101@redhat.com>
	<20070227.130305.424251739.hyoshiok@miraclelinux.com>
	<45E3B421.603@redhat.com>
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007 23:31:29 -0500, Rik van Riel <riel@redhat.com> wrote:

> Hiro Yoshioka wrote:
> > Hi,
> > 
> > From: Rik van Riel <riel@redhat.com>
> >> Hiro Yoshioka wrote:
> >>> Howdy,
> >>>
> >>> MySQL 5.0.26 had some scalability issues and it solved since 5.0.32
> >>> http://ossipedia.ipa.go.jp/capacity/EV0612260303/
> >>> (written in Japanese but you may read the graph. We compared
> >>> 5.0.24 vs 5.0.32)
> > snip
> >>> MySQL tries to get a mutex but it spends about 16.8% of CPU on 8 core
> >>> machine.
> >>>
> >>> I think there are a lot of room to be inproved in MySQL implementation.
> >> That's one aspect.
> >>
> >> The other aspect of the problem is that when the number of
> >> threads exceeds the number of CPU cores, Linux no longer
> >> manages to keep the CPUs busy and we get a lot of idle time.
> >>
> >> On the other hand, with the number of threads being equal to
> >> the number of CPU cores, we are 100% CPU bound...
> > 
> > I have a question. If so, what is the difference of kernel's
> > view between SMP and CPU cores?
> 
> None.  Each schedulable entity (whether a fully fledged
> CPU core or an SMT/HT thread) is treated the same.
> 

And what do the SMT and Multi-Core scheduling options in the kernel
config are for ?  Because of this thread I re-read the help text, and
it looks like on could de-select the SMT scheduler option, get a
working SMP system, and see what difference ? I suppose its related
to migration and cache flushing and so on, but where could I get
more details ?
And more strange, what is the difference between multi-core and
normal SMP configs ?

> > Another question. When the number of threads exceeds the number of
> > CPU cores, we may get a lot of idle time. Then a workaround of
> > MySQL is that do not creat threads which exceeds the number
> > of CPU cores. Is it right?
> 
> Not really, that would make it impossible for MySQL to
> handle more simultaneous database queries than the system
> has CPUs.
> 

I don't know myqsl internals, but you assume one thread per query.
If its more like Apache, one long living thread for several connections ?
Its the same to answer 4+4 queries than 8 at half the speed, isn't it ?

> Besides, it looks like this is not a problem in MySQL
> per se (it works on FreeBSD) but some bug in Linux.
> 


--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.19-jam07 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #2 SMP PREEMPT
