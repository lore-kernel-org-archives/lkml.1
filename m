Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZAMPVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZAMPVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZAMPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:21:09 -0500
Received: from tservice.net.ru ([195.178.208.66]:56973 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZAMPVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:21:09 -0500
Date: Tue, 13 Jan 2009 18:21:06 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090113152106.GA1134@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com> <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk> <20090113135246.GA29251@ioremap.net> <20090113140627.507f15e1@lxorguk.ukuu.org.uk> <20090113142423.GA30710@ioremap.net> <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 08:30:16PM +0530, Balbir Singh (balbir@linux.vnet.ibm.com) wrote:
> > It is created because of real needs. Because people need to control the
> > behaviour of the system and they want to control which application will
> > be killed to free the memory. Attached patch is not the best solution,
> > but it works for the all cases I can think about.
> >
> 
> Where does this end? Tomorrow you'll add an interface for applications
> that should *not* be killed? What sort of a heuristic is name? I think
> the only name the kernel knows about is "init".

We have an interface to disable oom for the process already :)
But I could agree that it could be a good idea to have an interface
to provide a list of names or whatever else to select what user knows
and works with to be killed first/last

> > Let's take you 'name aliasing' claim: if there are several processes
> > with the same name, system will select the one with the worst score
> > according to the own magical algorithm. So it will not kill random
> > process just because it happend to have ricky name.
> >
> 
> Having a name in the kernel is like building a hit-list, why can't the
> examples that Alan sent work for you?

Using oom_adj? Because there is no way I can determine which number to
put there. It is not even documented for those who do not read kernel
sources. Even after that: oom_score changes with time, and having 1/2 or
8 oom_adj is correct right now, it will not be in a few moments.

Having containers is a bit overkill to determine which one to kill,
especially when several sets of processes are created from the same
parent :)

> Names are tricky as well, if someone used a symbolic link to the
> application with a different name, they would no longer be candidates
> for OOM first? or vice-versa?

It is up to the user to decide what he wants to be checked first.
Only user knows what he runs.

> You can replace the lines of kernel code you wrote with a simple
> one-line script that Alan sent out.

Almost. But I can not if tasks are spawned from the parent process. We
can not change the process to adjust its forked children to have
different adjustment and can not change it for the process itself, since
it should live and children should be dead.

-- 
	Evgeniy Polyakov
