Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbXCEK2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbXCEK2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933046AbXCEK2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:28:47 -0500
Received: from www.osadl.org ([213.239.205.134]:39179 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933044AbXCEK2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:28:31 -0500
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump
	kernel)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070305080824.GA20583@elte.hu>
References: <6bffcb0e0703031531h3f0a86c6sda2522c0ca504765@mail.gmail.com>
	 <1173018209.24738.135.camel@localhost.localdomain>
	 <6bffcb0e0703040636q5a4ed3ekf5a0461052e8e018@mail.gmail.com>
	 <1173022668.24738.141.camel@localhost.localdomain>
	 <6bffcb0e0703040828j46a339c2ofabf7c0e20f6ae09@mail.gmail.com>
	 <1173026442.24738.143.camel@localhost.localdomain>
	 <6bffcb0e0703040847g1c04940bm4c22895ec2540bd1@mail.gmail.com>
	 <1173027823.24738.156.camel@localhost.localdomain>
	 <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com>
	 <20070305080824.GA20583@elte.hu>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 11:34:29 +0100
Message-Id: <1173090869.24738.198.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 09:08 +0100, Ingo Molnar wrote:
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/log2.txt
> 
> weird. Could you do a dump with SysRq-T, SysRq-Q done /twice/ after each 
> other, to see how the system progresses while in this lockup? Plus 
> please also try to get a register dump via SysRq-P. 
> 
> Btw., the task state printout seems busted:
> 
> udev_run_devd ? C15B0030  2544   979    853                     (L-TLB)
> 
> shouldnt that be 'R' instead of the question mark?

? are dead ones,  

 [<c16191d9>] do_exit+0x6f9/0x6fd
 [<c161924d>] sys_exit_group+0x0/0x11
 [<c161925c>] sys_exit_group+0xf/0x11
 [<c1603e72>] sysenter_past_esp+0x5f/0x99

The interesting part is here:

1 lock held by udevd/918:
 #0:  (&mm->mmap_sem){----}, at: [<c161135b>] do_page_fault+0x150/0x50d

But udevd/918 is nowhere in the sysrq-t output.

	tglx


