Return-Path: <linux-kernel-owner+w=401wt.eu-S1764656AbXESSYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656AbXESSYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763930AbXESSYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:24:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40213 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764124AbXESSYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:24:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-rc1 regression: tifm prevents suspending [was: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR]
Date: Sat, 19 May 2007 20:29:36 +0200
User-Agent: KMail/1.9.5
Cc: "Mattia Dongili" <malattia@linux.it>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Alex Dubov" <oakad@yahoo.com>,
       "Pierre Ossman" <drzeus@drzeus.cx>
References: <20070518071523.GA3195@inferi.kami.home> <20070519151110.GA3393@inferi.kami.home> <6bffcb0e0705191017n1d1e6eb7k1370d5ce5cf17fb9@mail.gmail.com>
In-Reply-To: <6bffcb0e0705191017n1d1e6eb7k1370d5ce5cf17fb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705192029.37436.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 19 May 2007 19:17, Michal Piotrowski wrote:
> Hi,
> 
> On 19/05/07, Mattia Dongili <malattia@linux.it> wrote:
> > On Sat, May 19, 2007 at 12:04:13AM -0700, Andrew Morton wrote:
> > > On Sat, 19 May 2007 15:48:29 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > >
> > > > On Fri, May 18, 2007 at 12:22:40AM -0700, Andrew Morton wrote:
> > > > > On Fri, 18 May 2007 16:15:24 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > > > >
> > > > > > Hello,
> > > > > >
> > > > > > After finally catching fw-{ohci,core} to be problematic during resume,
> > > > > > I'm now experiencing an immediate resume after suspending.
> > > > > >
> > > > > > 2.6.21-rc7-mm* didn't even suspend, my last known suspend-and-resuming
> > > > > > kernel was 2.6.21-rc5-mm3 (I know one other vaio SZ user could STR with
> > > > > > 2.6.21-rc6-mm* after the cpuidle fixes).
> > > > > >
> > > > > > my .config is: http://oioio.altervista.org/linux/config-2.6.22-rc1-mm1-1
> > > > > > and a str cycle with PM_DEBUG=y:
> > > > > > http://oioio.altervista.org/linux/dmesg-SRT-immediately-resumes.txt
> > > > ...
> > > > > > Any idea where to start from? (bisecting is ok, but it'll take some
> > > > > > time...)
> > > > >
> > > > > Bisecting isn't that bad ;) I'd pick git-acpi.patch as the starting point.
> > > >
> > > > ok, git-acpi.patch is not the bad boy :)
> > > > Anyway what we have is a regression in 2.6.22-rc1 since the laptop can't
> > > > suspend (it sits on the "Stopping tasks" console screen) while 2.6.21
> > > > can.
> > > > I'm now bisecting this, will come to -mm1 later when done with this one.
> > >
> > > OK, thanks.
> > >
> > > > Who is the regression-guy?
> > >
> > > Len, usually ;)    But I think you meant Michal, cc'ed here.
> >
> > LOL, not this time. We have the responsible commit for 2.6.22-rc1 (Cc
> > added):
> >
> > 3540af8ffddcdbc7573451ac0b5cd57a2eaf8af5 is first bad commit
> > commit 3540af8ffddcdbc7573451ac0b5cd57a2eaf8af5
> > Author: Alex Dubov <oakad@yahoo.com>
> > Date:   Thu Apr 12 16:59:15 2007 +1000
> >
> 
> Subject    : Broken suspend on SMP with tifm
> References : http://lkml.org/lkml/2007/5/13/161
> Submitter  : Rafael J. Wysocki <rjw@sisk.pl>
> Status     : patch was suggested
> 
> Actually should be "a few patches was suggested"
> 
> Rafael, please point me the right patch.

Fixed in the mainline, by

commit e3dfd2964ea86ae65f511b10d62ea54d46db3708
make freezeable workqueues singlethread

Greetings,
Rafael
