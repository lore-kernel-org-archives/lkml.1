Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbZGCTNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbZGCTNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbZGCTNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:13:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50745 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884AbZGCTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:13:19 -0400
Date: Fri, 3 Jul 2009 13:13:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Chinang Ma <chinang.ma@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       Matthew Wilcox <matthew.r.wilcox@intel.com>, Eric.Moore@lsi.com,
       DL-MPTFusionLinux@lsi.com
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090703191321.GO5480@parisc-linux.org>
References: <20090703025607.GK5480@parisc-linux.org> <87skhdaaub.fsf@basil.nowhere.org> <20090703185414.GP23611@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703185414.GP23611@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 08:54:14PM +0200, Jens Axboe wrote:
> On Fri, Jul 03 2009, Andi Kleen wrote:
> > 
> > Matthew Wilcox <matthew@wil.cx> writes:
> > >
> > > ======oprofile CPU_CLK_UNHALTED for top 30 functions
> > > Cycles% 2.6.18-92.el5-op           Cycles% 2.6.30
> > > 70.1409 <database>                 67.0207 <database>
> > > 1.3556 mpt_interrupt               1.7029 mpt_interrupt
> > 
> > It's strange that mpt_interrupt is that more costly in 2.6.30
> > than in 2.6.18. I diffed 2.6.30's drivers/message/fusion/mptbase.c
> > to a rhel 5.3s and they seem to be about the same. 
> > 
> > So why does it cost 0.5% more in 2.6.30?
> > 
> > [adding MPT maintainers]
> 
> Look at the irqs/sec rate, it's higher by about the same percentage. So
> it's likely not a more costly irq handler, it's likely just called that
> much more. It could be IO pattern, causing more commands to be issued
> (which leads to more interrupts, etc).

Yes, but the irqs/sec increase doesn't appear to be due to MPT interrupts.
In the /proc/interrupt summaries, RH5 did 388666895 IOC interrupts and
2.6.30 did 378419042.  As a percentage of interrupts, the IOC interrupts
were 59.4% with RH and 51.8% with 2.6.30.

This isn't quite conclusive since the collection of /proc/interrupts is
over the entire life of the system, not during the measurement period.
But I do find it persuasive.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
