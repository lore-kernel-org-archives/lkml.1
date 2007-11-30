Return-Path: <linux-kernel-owner+w=401wt.eu-S935272AbXK3PzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272AbXK3PzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932801AbXK3PzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:55:10 -0500
Received: from lazybastard.de ([212.112.238.170]:45129 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633AbXK3PzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:55:09 -0500
Date: Fri, 30 Nov 2007 16:49:37 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071130154936.GB30773@lazybastard.org>
References: <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <20071130125628.GA30773@lazybastard.org> <20071130133546.GB29679@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071130133546.GB29679@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 November 2007 14:35:46 +0100, Ingo Molnar wrote:
> * Jörn Engel <joern@logfs.org> wrote:
> > 
> > kernel/sched.c:3384: warning: ‘struct prio_array’ declared inside parameter list
> > kernel/sched.c:3384: warning: its scope is only this definition or declaration, which is probably not what you want
> > kernel/sched.c: In function ‘trace_array’:
> > kernel/sched.c:3391: error: dereferencing pointer to incomplete type
> > kernel/sched.c:3393: error: dereferencing pointer to incomplete type
> > kernel/sched.c:3393: error: dereferencing pointer to incomplete type
> > kernel/sched.c:3396: error: dereferencing pointer to incomplete type
> > kernel/sched.c:3396: error: dereferencing pointer to incomplete type
> > kernel/sched.c: In function ‘trace_all_runnable_tasks’:
> > kernel/sched.c:3407: error: ‘struct rq’ has no member named ‘active’
> > make[1]: *** [kernel/sched.o] Error 1
> > 
> > And I cannot find a definition of struct prio_array in current git
> > either.  Is another patch needed?
> 
> change that to rt_prio_array in the code.

Solves the prio_array problem, but leaves the non-existing member
active.  I've upgraded to -rc3 and will give your latest patch a whirl.

Jörn

-- 
Write programs that do one thing and do it well. Write programs to work
together. Write programs to handle text streams, because that is a
universal interface.
-- Doug MacIlroy
