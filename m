Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYGKKmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYGKKmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYGKKmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:42:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59285 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYGKKmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:42:08 -0400
Date: Fri, 11 Jul 2008 04:41:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, grundler@parisc-linux.org, mingo@elte.hu,
       tglx@linutronix.de, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       suresh.b.siddha@intel.com, benh@kernel.crashing.org,
       jbarnes@virtuousgeek.org, rdunlap@xenotime.net, mtk.manpages@gmail.com
Subject: Re: Multiple MSI, take 3
Message-ID: <20080711104151.GS14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org> <m1iqvc91li.fsf@frodo.ebiederm.org> <20080711102326.GR14894@parisc-linux.org> <20080711.033242.58168774.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711.033242.58168774.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 03:32:42AM -0700, David Miller wrote:
> From: Matthew Wilcox <matthew@wil.cx>
> Date: Fri, 11 Jul 2008 04:23:26 -0600
> 
> > On Fri, Jul 11, 2008 at 03:06:33AM -0700, Eric W. Biederman wrote:
> > > So unless the performance of the AHCI is better by a huge amount I don't
> > > see the point, and even then I am extremely sceptical.
> > 
> > I don't have performance numbers yet, but surely you can see that
> > avoiding a register read in the interrupt path is a large win?
> 
> Such overhead is going to be amortized.
> 
> AHCI is not like networking where we have lots of very small
> transactions to deal with, and therefore the per-IRQ overhead can
> begin to dominate.
> 
> Therefore, like Eric, I think workng on multiple MSI is a very dubious
> usage of one's time.  But, it's your time, so use it how you wish :)

I didn't start hacking without performance numbers ;-)  With an
I/O-heavy workload, the two biggest consumers of CPU time in the profile
were ahci_interrupt and ahci_qc_issue.  I got 10% more bandwidth by
removing the flushing readl() from ahci_qc_issue.  I'm hoping for a
similar improvement by removing this readl() too.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
