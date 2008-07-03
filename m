Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYGCL6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYGCL6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbYGCL4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:56:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419AbYGCL4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:56:14 -0400
Date: Thu, 3 Jul 2008 02:02:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, npiggin@suse.de,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik Van Riel <riel@redhat.com>
Subject: Re: [mmotm] build failure on x86_64 pci-calgary_64.c
Message-Id: <20080703020203.02cd14d4.akpm@linux-foundation.org>
In-Reply-To: <20080703174027.D6D7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <486C74B1.3000007@cn.fujitsu.com>
	<20080703161028.D6CC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080703174027.D6D7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2008 17:46:42 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > Seems the problematic patch is :
> > > mmap-handle-mlocked-pages-during-map-remap-unmap.patch
> > > 
> > > I'm using mmotm uploaded yesterday by Andrew, so I guess this bug
> > > has not been fixed ?
> > > 
> > > BUG: sleeping function called from invalid context at include/linux/pagemap.h:290
> > > in_atomic():1, irqs_disabled():0
> > 
> > sorry for that.
> > I started investigate this problem.
> 
> Hi Andrew,
> 
> on ia64, I can't reproduce this problem.
> on x86_64, I can't build kernel because following error happned.
>            (end_pfn doesn't exist, but used)
> 
> 
> -----------------------------------------------------
> % LANG=C make -j 20
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      arch/x86/kernel/pci-calgary_64.o
> arch/x86/kernel/pci-calgary_64.c: In function 'detect_calgary':
> arch/x86/kernel/pci-calgary_64.c:1413: error: 'end_pfn' undeclared (first use in this function)
> arch/x86/kernel/pci-calgary_64.c:1413: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/pci-calgary_64.c:1413: error: for each function it appears in.)
> make[1]: *** [arch/x86/kernel/pci-calgary_64.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> make: *** Waiting for unfinished jobs....
> make: *** wait: No child processes.  Stop.
> 

yup, thanks, I fixed that. 
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1
is there now.

