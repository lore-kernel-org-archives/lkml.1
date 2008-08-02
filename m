Return-Path: <linux-kernel-owner+w=401wt.eu-S1764124AbYHDWLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764124AbYHDWLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762726AbYHDWLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:11:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53332 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758276AbYHDWK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:10:56 -0400
Subject: Re: [PATCH 2/6] Container Freezer: Make refrigerator always
	available
From: Matt Helsley <matthltc@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Michael Opdenacker <michael@free-electrons.com>,
       linux-embedded@vger.kernel.org
In-Reply-To: <200808020053.18638.rjw@sisk.pl>
References: <20080801050659.924495279@us.ibm.com>
	 <20080801162712.63721e8c@surf>
	 <1217617689.25300.213.camel@localhost.localdomain>
	 <200808020053.18638.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-7
Organization: IBM Linux Technology Center
Date: Fri, 01 Aug 2008 19:30:26 -0700
Message-Id: <1217644226.25300.296.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-08-02 at 00:53 +-0200, Rafael J. Wysocki wrote:
+AD4 On Friday, 1 of August 2008, Matt Helsley wrote:
+AD4 +AD4 
+AD4 +AD4 On Fri, 2008-08-01 at 16:27 +-0200, Thomas Petazzoni wrote:
+AD4 +AD4 +AD4 Hi,
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 Le Thu, 31 Jul 2008 22:07:01 -0700,
+AD4 +AD4 +AD4 Matt Helsley +ADw-matthltc+AEA-us.ibm.com+AD4 a +AOk-crit :
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 +AD4 --- a/kernel/Makefile
+AD4 +AD4 +AD4 +AD4 +-+-+- b/kernel/Makefile
+AD4 +AD4 +AD4 +AD4 +AEAAQA -5,7 +-5,7 +AEAAQA
+AD4 +AD4 +AD4 +AD4  obj-y     +AD0 sched.o fork.o exec+AF8-domain.o panic.o printk.o +AFw
+AD4 +AD4 +AD4 +AD4  	    cpu.o exit.o itimer.o time.o softirq.o resource.o +AFw
+AD4 +AD4 +AD4 +AD4  	    sysctl.o capability.o ptrace.o timer.o user.o +AFw
+AD4 +AD4 +AD4 +AD4 -	    signal.o sys.o kmod.o workqueue.o pid.o +AFw
+AD4 +AD4 +AD4 +AD4 +-	    signal.o sys.o kmod.o workqueue.o pid.o freezer.o +AFw
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 I have the impression that the code in kernel/power/process.c was
+AD4 +AD4 +AD4 compiled only if CONFIG+AF8-PM+AF8-SLEEP was set. Now that the code has been
+AD4 +AD4 +AD4 moved to kernel/freezer.c, it is unconditionnaly compiled in every
+AD4 +AD4 +AD4 kernel. Is that correct ?
+AD4 +AD4 +AD4
+AD4 +AD4 +AD4 If so, is it possible to put this new feature under some
+AD4 +AD4 +AD4 CONFIG+AF8-SOMETHING option, for people who care about the kernel size ?
+AD4 +AD4 
+AD4 +AD4 	How about making it depend on a combination of CONFIG variables?
+AD4 +AD4 Here's an RFC PATCH. Completely untested.
+AD4 +AD4 
+AD4 +AD4 Signed-off-by: Matt Helsley +ADw-matthltc+AEA-us.ibm.com+AD4
+AD4 
+AD4 Can you please also make the contents of include/linux/freezer.h depend on
+AD4 CONFIG+AF8-FREEZER instead of CONFIG+AF8-PM+AF8-SLEEP?

Done.

+AD4 Also, I'm not really sure if kernel/power/Kconfig is the right place to define
+AD4 CONFIG+AF8-FREEZER.
+AD4 
+AD4 Perhaps we should even move freezer.c from kernel/power to kernel
+AD4 and define CONFIG+AF8-FREEZER in Kconfig in there.  Andrew, what do you think?

	I'll check this weekend for replies and repost the RFC PATCH on Monday
if I don't hear anything. In the meantime I'll be doing some config
build testing with the above changes to make sure it's correct.

Cheers,
	-Matt

