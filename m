Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZAIGZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZAIGZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZAIGZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:25:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60610 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZAIGZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:25:27 -0500
Date: Fri, 9 Jan 2009 15:24:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
Message-Id: <20090109152422.82020371.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4966EB5F.4010506@cn.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	<4966EB5F.4010506@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2009 14:14:55 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > How about this idea ? Any comments are welcome.
> > 
> > -Kame
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Add an NO OPERATION cgroup subsystem.
> > 
> > Cgroup itself is providing a feature to attach a task(PID) to some class.
> > This feature itself is very useful but "no operation" cgroup is not supported
> > now other than debug cgroup. (But debug cgroup should be for DEBUG. distro
> > may not configure it.)
> > 
> 
> Then how can we make sure distro will configure this noop subsys. :)
> 
I'll ask ;) or set default to y. (because there is almost no overhead.)

> Or we can make the debug subsys always configured if CONFIG_CGROUP=y ?
> The debug system adds no runtime overhead, and it's about 100 lines
> of code only.
> 
I considered that at fist. I wrote this for 2 reasones.
 - Name of "debug" is no suitable for general use.
 - I wonder I can add some more debug support to debug cgroup like fault
   injection. For example,

   Add an create_may_fail file to debug cgroup.
   # echo 1 > debug.create_may_fail

   When create_may_fail is "1", debug->create() will fail at 50% of probability.
   (to make this test more useful, we should move debug_cgroup's subsys id to
    be more higher.)
   I'd like to add this kind of debug feature to debug cgroup when memcg is settled.

-Kame

> > Motivation: Simply classify Applications by cgroup
> >   When using cgroup for classifying applications, some kind of "control" or
> >   "account" subsys must be used. For flexible use of cgroup's nature of
> >   classifying applications, NOOP is useful. It can be used regardless of
> >   resource accounting unit or name spaces or some controls.
> >   IOW, NOOP cgroup allows users to tie PIDs with some nickname.
> > 
> > After this, application can be checked whether it's still alive or not by
> > 
> > 	mount -t cgroup none /var/apps noop
> > 	mkdir /var/apps/mydaemon
> > 	echo 0 > /var/apps/mydaemon
> > 	/etc/init.d/mydaemon start
> > 	exit
> > 
> > This can be used as the same technique of "recording pid into /var/run/xxx.pid"
> > and not necessary to remove stale files. If mydaemon dies, tasks file will
> > be empty and notify_on_release handler can be used.
> > 
> > I myself want to use this for replacement of "ps -elf | grep" if libcgroup supports
> > ps under cgroup.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

