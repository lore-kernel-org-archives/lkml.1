Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZBEPC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZBEPC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZBEPCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:02:47 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:40877 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbZBEPCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:02:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEALGOiklMQWt2/2dsb2JhbACBbs9WhBYG
Date: Thu, 5 Feb 2009 10:02:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: LTTng 0.89 for Linux 2.6.29-rc3
Message-ID: <20090205150242.GA27895@Krystal>
References: <20090130200757.GA14999@Krystal> <20090205140432.GE6915@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090205140432.GE6915@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:56:02 up 35 days, 14:54,  7 users,  load average: 0.45, 0.31,
	0.23
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Fri, Jan 30, 2009 at 03:07:57PM -0500, Mathieu Desnoyers wrote:
> > Hi,
> > 
> > I just ported LTTng to the 2.6.29-rc3 kernel. It includes the following
> > changes :
> > 
> > - Tree RCU instrumentation
> > - Updated ext4 and jbd2 instrumentation
> > 
> > Please feel free to try it and report any success/problem you may have.
> > Note that cross-build has been slightly less tested this time because
> > I'll have to upgrade many of my compilers to a version compatible with
> > kernel 2.6.29-rc.
> > 
> > It also includes the recently added kprobes support through a simple
> > 
> > echo symbol_name > /mnt/debugfs/ltt/kprobes/enable
> > 
> > It's available at the new LTTng website :
> > 
> > http://www.lttng.org/
> 
> Hello, Matheiu,
> 
> When I try to apply this to v2.6.29-rc3, I get the following:
> 
> 	can't find file to patch at input line 61
> 	Perhaps you used the wrong -p or --strip option?
> 	The text leading up to this was:
> 	--------------------------
> 	|get_ltt_root() is necessary for ltt-trace-control to create subdirs in
> 	ltt's
> 	|debugfs dir.
> 	|
> 	|From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 	|Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> 	|Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 	|---
> 	| include/linux/ltt-core.h |    8 ++++++++
> 	| ltt/ltt-core.c           |   14 ++++++++++++++
> 	| ltt/ltt-relay.c          |    8 +-------
> 	| 3 files changed, 23 insertions(+), 7 deletions(-)
> 	|
> 	|Index: linux-2.6-lttng/include/linux/ltt-core.h
> 	|===================================================================
> 	|--- linux-2.6-lttng.orig/include/linux/ltt-core.h      2009-01-15
> 	15:55:18.000000000 -0500
> 	|+++ linux-2.6-lttng/include/linux/ltt-core.h   2009-01-15
> 	15:55:24.000000000 -0500
> 
> Help?
> 

Hi Paul,

I must admit I'm a bit puzzled. I've tried to quilt push -a both 
LTTng 0.89 and LTTng 0.92 taken from the website and they both apply
correctly on 2.6.29-rc3. When I quilt pop -a, neither of those 3 files
(include/linux/ltt-core.h, ltt/ltt-core.c, ltt/ltt-relay.c) are stucked
in my tree.

I've used files from :

http://www.lttng.org/files/lttng/patch-2.6.29-rc3-lttng-0.92.tar.bz2

Which tarballs are you using exactly ?

I guess you need to apply them to your existing tree, so pointing you to
git.kernel.org lttng tree won't help much here.

Mathieu

> 							Thanx, Paul

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
