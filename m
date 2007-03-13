Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbXCMDHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbXCMDHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 23:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbXCMDHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 23:07:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50299 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbXCMDHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 23:07:10 -0400
Date: Tue, 13 Mar 2007 08:44:11 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Anton Blanchard <anton@samba.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070313031411.GC9881@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl> <20070312223906.GA9749@elf.ucw.cz> <20070312224524.GB807@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312224524.GB807@kryten>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 05:45:24PM -0500, Anton Blanchard wrote:
> Then please document it _clearly_ with the kthread code somewhere. 

Document as well in the kernel_thread() API, as I notice people still
use kernel_thread() some places (ex: rtasd.c in powerpc arch)?

> The reason I brought this up is I had no idea we had to put the freezer gunk
> in all kernel thread loops and Ive been writing kernel threads for years.

I noticed that in the Powerpc code (atleast for rtas kernel thread)
here:

	http://lkml.org/lkml/2007/1/9/61

That was not a serious problem perhaps because process freezer was mostly used
in software suspend and only those platforms supporting software suspend
had to worry abt it.

But now we intend to use process freezer for CPU hotplug as well, so all
platforms wanting to support CPU hotplug better support process freezer!

P.S : I believe kprobes is already using process freezer as well.

-- 
Regards,
vatsa
