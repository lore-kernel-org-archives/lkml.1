Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbXFWXsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbXFWXsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 19:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXFWXsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 19:48:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34442 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbXFWXsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 19:48:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Date: Sun, 24 Jun 2007 01:54:52 +0200
User-Agent: KMail/1.9.5
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
References: <20070606231642.GH13751@tree.beaverton.ibm.com> <20070619204929.GM9751@tree.beaverton.ibm.com> <20070619220812.GG7160@linux-os.sc.intel.com>
In-Reply-To: <20070619220812.GG7160@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706240154.53351.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 June 2007 00:08, Siddha, Suresh B wrote:
> On Tue, Jun 19, 2007 at 01:49:30PM -0700, Darrick J. Wong wrote:
> > 
> > This fixes the problem!  Hurrah!
> 
> Great!  Andrew, please include the appended patch in -mm.
> 
> ----
> Subject: [patch] x86_64, irq: use mask/unmask and proper locking in fixup_irqs
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> Force irq migration path during cpu offline, is not using proper
> locks and irq_chip mask/unmask routines. This will result in
> some races(especially the device generating the interrupt can see
> some inconsistent state, resulting in issues like stuck irq,..).
> 
> Appended patch fixes the issue by taking proper lock and
> encapsulating irq_chip set_affinity() with a mask() before and an
> unmask() after.
> 
> This fixes a MSI irq stuck issue reported by Darrick Wong.
> 
> There are several more general bugs in this area(irq migration in the
> process context). For example,
> 
> 1. Possibility of missing edge triggered irq.
> 2. Reliable method of migrating level triggered irq in the process context.
> 
> We plan to look and close these in the near future.

This patch breaks hibernation on my Turion 64 X2 - based testbox (HPC nx6325).

_cpu_down() just hangs as though there were a deadlock in there, 100% of the
time.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
