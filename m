Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZJNEyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZJNEyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbZJNEyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:54:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50603 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZJNEyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:54:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Oct 2009 13:51:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: vedran.furac@gmail.com
Cc: Vedran =?UTF-8?B?RnVyYcSN?= <vedranf@vedranf.mine.nu>,
       linux-kernel@vger.kernel.org
Subject: Re: Memory overcommit
Message-Id: <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <hb2cfu$r08$2@ger.gmane.org>
References: <hav57c$rso$1@ger.gmane.org>
	<20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>
	<hb2cfu$r08$2@ger.gmane.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 19:13:34 +0200
Vedran Furač <vedranf@vedranf.mine.nu> wrote:

> KAMEZAWA Hiroyuki wrote:
> > I guess the reason of default value is that the kernel assume
> > processes will not always use all mmaped range. There will be unused
> > range in process's virtual memory and it can be big.
> > 
> > For example, typical case in a server, when you run multi-thread
> > program (like java VM),
> > 
> > - stack per thread - malloc() arena per thread
> > 
> > can makes difference among size-of-mapped-range v.s. used-pages
> > bigger. I saw Gigabytes of unused range on ia64 host,...statck size
> > was big.
> 
> Yes, I noticed that JVM allocates gigabytes but then uses less than 10%
> of that and, as a consequence, eclipse sometimes fails to start although
> there's plenty of free memory. So overcommiting is some kind of a
> workaround for broken software that allocate not what they need but what
> they might need in some rare occurrences. I would rather like fixing
> this userland software than risking OOM situations and random killing of
> innocent processes.
> 

In my understanding, mmap() is just for requesting virtual address space.
Not for requesting memory in these days.



> > And if strict check(vm.ovecommit_memory=2) is used, mmap() return
> > -ENOMEM whenever it hits limit.
> 
> % strace -f -e mmap java -version
> [...]
> mmap(NULL, 996147200, PROT_READ|PROT_WRITE|PROT_EXEC,
> MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 ENOMEM (Cannot
> allocate memory)
> 
> And that should be fine.
> 
It's not fine for me ;)

> > Against random-kill, you may have 2 choices.
> > 
> > 1. use  /proc/<pid>/oom_adj 2. use  memory cgroup.
> > 
> > Something more easy-to-use method may be appriciated. We have above 2
> > now.
> 
> These are just bad workarounds for bad OOM algorithm. I tested this
> little program on multiple systems (including windows) without any
> tweaking and linux behavior is, unfortunately *the worst*.  :/
> 
> 
Yes, they are workaround. You can use /etc/sysctl.conf.
But if making it default _now_, many threaded programs will not work.
 
But I agree, OOM killer should be sophisticated.
Please give us a sample program/test case which causes problem.
linux-mm@kvack.org may be a better place. lkml has too much traffic.

Regards,
-Kame

