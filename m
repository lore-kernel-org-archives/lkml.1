Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbZCOEzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbZCOEzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZCOEzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:55:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZCOEzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:55:04 -0400
Date: Sun, 15 Mar 2009 05:54:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: kdebugfs.c cleanup
Message-ID: <20090315045446.GD11150@elte.hu>
References: <1237042917.4546.15.camel@ht.satnam> <49BC8182.5050508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BC8182.5050508@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> >  #include <linux/debugfs.h>
> >  #include <linux/uaccess.h>
> > -#include <linux/stat.h>
> > +#include <linux/module.h>
> >  #include <linux/init.h>
> > +#include <linux/stat.h>
> >  #include <linux/io.h>
> >  #include <linux/mm.h>
> > -#include <linux/module.h>
> >  
> 
> Just curious about the rule to sort those includes, and why they need
> to be rearranged.

Such includes (the 'reverse christmas tree'):

#include <linux/interrupt.h>
#include <linux/mmiotrace.h>
#include <linux/bootmem.h>
#include <linux/compiler.h>
#include <linux/highmem.h>
#include <linux/kprobes.h>
#include <linux/uaccess.h>
#include <linux/vmalloc.h>
#include <linux/vt_kern.h>
#include <linux/signal.h>
#include <linux/kernel.h>
#include <linux/ptrace.h>
#include <linux/string.h>
#include <linux/module.h>
#include <linux/kdebug.h>
#include <linux/errno.h>
#include <linux/magic.h>
#include <linux/sched.h>
#include <linux/types.h>
#include <linux/init.h>
#include <linux/mman.h>
#include <linux/tty.h>
#include <linux/smp.h>
#include <linux/mm.h>

#include <asm/kmemcheck.h>
#include <asm/tlbflush.h>
#include <asm/pgalloc.h>
#include <asm/segment.h>
#include <asm/system.h>
#include <asm/proto.h>
#include <asm/traps.h>
#include <asm/desc.h>

are used by x86 architecture code (and some other subsystems) to 
reduce the likelyhood of patch conflicts in commonly modified 
kernel files.

Without such ordering developers typically append to the 
existing list of include files when introducing a new header - 
creating an almost certain patch conflict. Via the above 
ordering, new headers get distributed roughly evenly amongst the 
full range - and thus the chance of patch conflicts is much 
smaller.

This way it also looks a bit more structured and bit less messy. 
It looks unprofessional and sloppy if a .c file starts with a 
big block of thrown-together include files.

	Ingo
