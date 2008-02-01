Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbYBAVHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYBAVHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758086AbYBAVG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:06:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:59834 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758384AbYBAVG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:06:57 -0500
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 01 Feb 2008 22:06:56 +0100
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <20080201202518.GJ18688@csn.ul.ie>
Message-ID: <20080201210656.174030@gmx.net>
MIME-Version: 1.0
References: <20080201184254.174020@gmx.net> <20080201191119.GI18688@csn.ul.ie>
 <20080201200518.174050@gmx.net> <20080201202518.GJ18688@csn.ul.ie>
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
To: Mel Gorman <mel@csn.ul.ie>
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18gKZNEj+4gwePNFwSJR+N+B7+tHEVH3L2kHS3BtK
 of0+WZN7vXb9NTqRBRb4GUo+0DFAdNgp1l5A== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: wrCQf853MmA6eEVmNmFnIAY5MjQ1N52E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
> Datum: Fri, 1 Feb 2008 20:25:18 +0000
> Von: Mel Gorman <mel@csn.ul.ie>
> An: Gerhard Pircher <gerhard_pircher@gmx.net>
> CC: linux-kernel@vger.kernel.org
> Betreff: Re: Commit for mm/page_alloc.c breaks boot process on my machine

> I meant uninitialised memory but I also wonder could something like this
> happen if you are trying to use memory that doesn't exist. i.e. you are
> trying to access more memory than you really have but you indicate later
> that this is not the case.
Good question. The memory is in the physical address range from 0x00000000
to 0x60000000 (1536MB).

> > > 2. Any chance of seeing a dmesg log?
> > That's a little bit of a problem. The kernel log in memory doesn't show
> > any kernel oops, but is also fragmented (small fragments seem to have
> > been overwritten with 0x0).
> 
> err, that doesn't sound very healthy.
Yeah, I know. But the platform code hasn't changed much when porting it
from arch/ppc to arch/powerpc. That's why I'm a little bit lost in this
case. :-)

> > Well, I can't answer this question. The kernel currently locks up when
> > loading the INIT program. But that is another problem (I still have to
> > bisect it) and doesn't seem to be related to this problem.
> 
> INIT would be the first MOVABLE allocation so it would be using memory
> at the end of the physical adddress range. i.e. the crash happens when
> memory towards the end and the only difference between the patch applied
> and reverted is when it happens.
Oh, that sounds interesting!

> Could you try booting with 16MB less memory using mem=?
I started the kernel with 512MB RAM (mem=496) and 1.5GB (mem=1520). The
kernel oopes in both cases with a "Unable to handle kernel paging request
for data address 0xbffff000", followed by a "Oops: kernel access of bad
area, sig 11" message. The end of the stack trace shows the start_here()
function.
I'm not a PowerPC expert, but if 0xbffff000 is a virtual address, then
it would be in the user program address space, right? If it is a physical
address, then it is somewhere in the unallocated PCI address space.

Gerhard

-- 
Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser
