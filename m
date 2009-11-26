Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZKZFp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZKZFp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZKZFpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:45:25 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:65067 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZKZFpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:45:25 -0500
Date: Thu, 26 Nov 2009 14:44:55 +0900 (JST)
Message-Id: <20091126.144455.508149124281697063.mitake@dcl.info.waseda.ac.jp>
To: dvhltc@us.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, walken@google.com,
       a.p.zijlstra@chello.nl, paulus@samba.org, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] perf bench: Add wrappers for atomic operation of
 GCC
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <4B0C07C2.7090608@us.ibm.com>
References: <20091118033741.GB23808@google.com>
	<1259073555-7312-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<4B0C07C2.7090608@us.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH 1/3] perf bench: Add wrappers for atomic operation of GCC
Date: Tue, 24 Nov 2009 08:20:18 -0800

Hi Darren,

> > It contains wrappers for atomic operation of GCC,
> > I think this is useful not only for 'perf bench',
> > but also for entire of perf command.
> > 
> > This patch adds new typedefed struct 'atomic_t'.
> > I know new typedef is not a thing to welcome,
> > but I believe that atomic_t is worth to typedef
> > because it is much general.
> > 
> > I borrowed this file from Darren Hart's futextest.
> > http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
> 
> Hi Hitoshi-san,
> 
> I took the gcc built-ins approach for futextest.h because I didn't want 
> the hassle of maintaining per-arch asm files. Since perf is already in 
> the kernel source, I wonder if you could leverage the already existing 
> kernel atomic code? See Documentation/atomic_ops.txt.

Yes, kernel source has atomic operations for every architecture.
But some architectures which has no 64bit atomic ops, like x86_32,
uses lib/atomic64.c.

And headers provided by arch depends on autoconf.h.
So if I use kernel atomic code, 'make menuconfig' must be done
before building perf. I think it's not good for users.

So I borrowed your approach.

> 
> > 
> > Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > Cc: Michel Lespinasse <walken@google.com>
> > Cc: Darren Hart <dvhltc@us.ibm.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  tools/perf/util/include/asm/atomic.h |   91 ++++++++++++++++++++++++++++++++++
> >  1 files changed, 91 insertions(+), 0 deletions(-)
> >  create mode 100644 tools/perf/util/include/asm/atomic.h
> > 
> > diff --git a/tools/perf/util/include/asm/atomic.h b/tools/perf/util/include/asm/atomic.h
> > new file mode 100644
> > index 0000000..1cef451
> > --- /dev/null
> > +++ b/tools/perf/util/include/asm/atomic.h
> > @@ -0,0 +1,91 @@
> > +/******************************************************************************
> > + *
> > + *   Copyright B) International Business Machines  Corp., 2009
> 
> B) should be © (or (C) at the very least), I'm guessing character set issue?

Sorry:( This must be character set issue. I'll fix.

Thanks
	Hitoshi
