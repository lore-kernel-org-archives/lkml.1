Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYDJWIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYDJWIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYDJWIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:08:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39408 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYDJWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:08:34 -0400
Date: Thu, 10 Apr 2008 15:07:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       mingo <mingo@redhat.com>
Subject: Re: linux-next: Tree for April 10 (ftrace)
Message-Id: <20080410150748.1bf2a8a8.randy.dunlap@oracle.com>
In-Reply-To: <20080410181404.b76939a6.sfr@canb.auug.org.au>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 18:14:04 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> [I have been asked to provide a summary of changes before the biolerplate
> so here goes (please tell me if this is what you want or not).  I am not
> going to try to describe the changes in the individual trees, just the
> interactions between them.]
> 
> Changes since next-20080410:
> 
> I no longer revert "x86: phase out forced inlining".
> There is a new conflict in arch/s390/lib/uaccess_pt.c between the s390 and
> 	kvm trees.
> There is a new trivial white space conflict in arch/ia64/kernel/mca.c.
> I no longer need to revert "wusb: add the wireless usb stack to Linux".
> 
> Today's Next/Trees file is lying: the x86-latest and sched-latest trees
> did not merge/build correctly so have not been included.
> 
> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (tar balls at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

trace selftest build fails when CONFIG_RT_MUTEXES=n:

next-20080410/kernel/trace/trace_selftest.c:413: error: implicit declaration of function 'rt_mutex_setprio'
make[3]: *** [kernel/trace/trace.o] Error 1

Possible fixes:

kernel/trace/Kconfig: SCHED_TRACER can depend on RT_MUTEXES
or there can be a stub for rt_mutex_setprio() when RT_MUTEXES=n

And kernel/trace/trace_selftest.c still needs #include <sched.h> added to it.

---
~Randy
