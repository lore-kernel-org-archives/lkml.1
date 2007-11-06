Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbXKFCx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbXKFCx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 21:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbXKFCxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 21:53:19 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41976 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755617AbXKFCxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 21:53:18 -0500
Date: Tue, 6 Nov 2007 03:52:53 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Brian Gerst <bgerst@didntduck.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] x86: arch/x86/Kconfig.cpu unification
Message-ID: <20071106025253.GF3444@stusta.de>
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org> <11941338801910-git-send-email-sam@ravnborg.org> <472FBB13.9070608@didntduck.org> <20071106024630.GA900@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071106024630.GA900@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 03:46:30AM +0100, Sam Ravnborg wrote:
> On Mon, Nov 05, 2007 at 07:53:39PM -0500, Brian Gerst wrote:
> > Sam Ravnborg wrote:
> > > Move all CPU definitions to Kconfig.cpu
> > 
> > This patch causes build failure on x86_64:
> > 
> > lib/rwsem.c: In function ‘__init_rwsem’:
> > lib/rwsem.c:24: error: ‘struct rw_semaphore’ has no member named ‘count’
> > lib/rwsem.c:24: error: ‘RWSEM_UNLOCKED_VALUE’ undeclared (first use in
> > this function)
> > lib/rwsem.c:24: error: (Each undeclared identifier is reported only once
> > lib/rwsem.c:24: error: for each function it appears in.)
> > lib/rwsem.c: In function ‘__rwsem_do_wake’:
> > lib/rwsem.c:64: error: implicit declaration of function
> > ‘rwsem_atomic_update’
> > lib/rwsem.c:64: error: ‘RWSEM_ACTIVE_BIAS’ undeclared (first use in this
> > function)
> > lib/rwsem.c:66: error: ‘RWSEM_ACTIVE_MASK’ undeclared (first use in this
> > function)
> > lib/rwsem.c:115: error: ‘RWSEM_WAITING_BIAS’ undeclared (first use in
> > this function)
> > lib/rwsem.c:120: error: implicit declaration of function ‘rwsem_atomic_add’
> > lib/rwsem.c: In function ‘rwsem_down_failed_common’:
> > lib/rwsem.c:169: error: ‘RWSEM_ACTIVE_MASK’ undeclared (first use in
> > this function)
> > lib/rwsem.c: In function ‘rwsem_down_read_failed’:
> > lib/rwsem.c:197: error: ‘RWSEM_WAITING_BIAS’ undeclared (first use in
> > this function)
> > lib/rwsem.c:197: error: ‘RWSEM_ACTIVE_BIAS’ undeclared (first use in
> > this function)
> > lib/rwsem.c: In function ‘rwsem_down_write_failed’:
> > lib/rwsem.c:210: error: ‘RWSEM_ACTIVE_BIAS’ undeclared (first use in
> > this function)
> > 
> > git bisect gives:
> > 55432d383871d127685d78f94e0ad60307dcc0e9 is first bad commit
> > commit 55432d383871d127685d78f94e0ad60307dcc0e9
> > Author: Sam Ravnborg <sam@ravnborg.org>
> > Date:   Thu Nov 1 21:54:39 2007 +0100
> > 
> >     x86: arch/x86/Kconfig.cpu unification
> 
> Seems that a default value fail to change value when we shift
> from 32 to 64 bit. I have it reproduced here.
> Will look at it tonight.

The problem is that you source arch/x86/Kconfig.cpu from 
arch/x86/Kconfig.x86_64 but didn't give RWSEM_XCHGADD_ALGORITHM 
the required dependency on X86_32.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

