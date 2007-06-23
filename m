Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbXFWX7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbXFWX7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 19:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXFWX6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 19:58:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbXFWX6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 19:58:54 -0400
Date: Sat, 23 Jun 2007 16:58:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-Id: <20070623165841.1c8f705c.akpm@linux-foundation.org>
In-Reply-To: <200706240154.53351.rjw@sisk.pl>
References: <20070606231642.GH13751@tree.beaverton.ibm.com>
	<20070619204929.GM9751@tree.beaverton.ibm.com>
	<20070619220812.GG7160@linux-os.sc.intel.com>
	<200706240154.53351.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 01:54:52 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, 20 June 2007 00:08, Siddha, Suresh B wrote:
> > On Tue, Jun 19, 2007 at 01:49:30PM -0700, Darrick J. Wong wrote:
> > > 
> > > This fixes the problem!  Hurrah!
> > 
> > Great!  Andrew, please include the appended patch in -mm.
> > 
> > ----
> > Subject: [patch] x86_64, irq: use mask/unmask and proper locking in fixup_irqs
> > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > 
> > Force irq migration path during cpu offline, is not using proper
> > locks and irq_chip mask/unmask routines. This will result in
> > some races(especially the device generating the interrupt can see
> > some inconsistent state, resulting in issues like stuck irq,..).
> > 
> > Appended patch fixes the issue by taking proper lock and
> > encapsulating irq_chip set_affinity() with a mask() before and an
> > unmask() after.
> > 
> > This fixes a MSI irq stuck issue reported by Darrick Wong.
> > 
> > There are several more general bugs in this area(irq migration in the
> > process context). For example,
> > 
> > 1. Possibility of missing edge triggered irq.
> > 2. Reliable method of migrating level triggered irq in the process context.
> > 
> > We plan to look and close these in the near future.
> 
> This patch breaks hibernation on my Turion 64 X2 - based testbox (HPC nx6325).
> 
> _cpu_down() just hangs as though there were a deadlock in there, 100% of the
> time.
> 

Thanks, I dropped it.
