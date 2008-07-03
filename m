Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbYGCM4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbYGCM4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYGCM4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:56:03 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:60960 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbYGCM4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:56:01 -0400
Date: Thu, 3 Jul 2008 11:07:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, npiggin@suse.de,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik Van Riel <riel@redhat.com>
Subject: Re: [mmotm] build failure on x86_64 pci-calgary_64.c
Message-ID: <20080703090722.GA17350@elte.hu>
References: <486C74B1.3000007@cn.fujitsu.com> <20080703161028.D6CC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080703174027.D6D7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703174027.D6D7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

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
> -----------------------------------------------------
> 
> 
> I guess below commit or related commit is doubtfully.
> 
> :commit 1b1b18f0bf62ec808784002382f2b5833701afda
> :Author: Yinghai Lu <yhlu.kernel@gmail.com>
> :Date:   Tue Jun 24 22:14:09 2008 -0700
> :
> :    x86: remove end_pfn in 64bit
> :
> :    and use max_pfn directly.
> :
> :    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> :    Signed-off-by: Ingo Molnar <mingo@elte.hu>

no.

this a linux-next integration artifact AFAICT, there's no such build 
failure in the x86 tree.

what happened is that the x86 tree got rid of end_pfn, the PCI tree grew 
one more reference to it and it was not fixed up.

	Ingo
