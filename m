Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZFZW6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZFZW6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZFZW55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:57:57 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43962 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZFZW54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:57:56 -0400
Date: Fri, 26 Jun 2009 18:57:47 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/2] do_coredump: misc cleanups
Message-ID: <20090626225747.GA15540@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180222.GD7337@hmsreliant.think-freely.org> <20090626165908.GB12063@redhat.com> <20090626202411.GH7337@hmsreliant.think-freely.org> <20090626191418.GA22603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626191418.GA22603@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 09:14:18PM +0200, Oleg Nesterov wrote:
> On 06/26, Neil Horman wrote:
> >
> > On Fri, Jun 26, 2009 at 06:59:08PM +0200, Oleg Nesterov wrote:
> > >
> > > Doesn't look good, if core_pattern starts with "|" any user can set
> > > RLIMIT_CORE = 0 and then just do
> > >
> > > 	for (;;)
> > > 		if (pid = fork())
> > > 			kill(pid, SIGQUIT);
> > >
> > > to DOS printk/syslog, no?
> > >
> > I don't think SIGQUIT will trigger this, but SIGSEGV will.
> 
> SIGQUIT falls into SIG_KERNEL_COREDUMP_MASK too.
> 
> > Regardless, if you
> > do that, I would think you have bigger problems on your system.
> 
> OK, agreed.
> 
> 
> Neil, I think you are doing useful changes, but can't we cleanup
> do_coredump() first?
> 
Thank you, and yes, I've got no problem cleaning up do_coredump first

> I just can't look at unnecessary "if (ispipe)" checks...
> 
I can get behind that.  I've got some stuff to do this weekend, so I'll wait to
let Andrew roll in your cleanup patches that you've posted (I've got a bunch of
weekend chores anyway), then early next week I'll rediff my patches with your
changes in place + Andrews new set of notes.

Thanks!
Neil

P.S. Andrew - I doubled checked, and my patches are on a branch in my git tree
rooted at tag v2.6.28-rc2 with your latest mm1 patch applied:
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.28-rc2/2.6.28-rc2-mm1/2.6.28-rc2-mm1.bz2
So I'm not sure where the conflicts are comming from.  I'll re-clone the tree
and apply everything from scratch though once Olegs patches are in place, to see
if theres something I missed.


> Oleg.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
