Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYIVMIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYIVMIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYIVMIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:08:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47824 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYIVMIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:08:09 -0400
Date: Mon, 22 Sep 2008 14:07:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: markus.t.metzger@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Roland McGrath <roland@redhat.com>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: [patch] x86, ptrace: void dopiness
Message-ID: <20080922120743.GF14301@elte.hu>
References: <20080919145250.A6000@sedona.ch.intel.com> <20080922115058.GB14301@elte.hu> <029E5BE7F699594398CA44E3DDF5544402781F00@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544402781F00@swsmsx413.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu] 
> >Sent: Montag, 22. September 2008 13:51
> >To: Metzger, Markus T
> >Cc: markus.t.metzger@gmail.com; linux-kernel@vger.kernel.org; 
> >akpm@linux-foundation.org; Roland McGrath
> >Subject: Re: [patch] x86, ptrace: void dopiness
> >
> >
> >* Markus Metzger <markus.t.metzger@intel.com> wrote:
> >
> >> +++ gits.x86/arch/x86/kernel/ptrace.c	2008-09-19 
> >13:53:02.%N +0200
> >> @@ -738,7 +738,7 @@
> >>  		unsigned int sig = 0;
> >>  
> >>  		/* we ignore the error in case we were not 
> >tracing child */
> >> -		(void)ds_release_bts(child);
> >> +		ds_release_bts(child);
> >
> >hm, here the cast is OK because we actually ignore the return value.
> >
> >> @@ -947,7 +947,7 @@
> >>  	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
> >>  #endif
> >>  #ifdef CONFIG_X86_PTRACE_BTS
> >> -	(void)ds_release_bts(child);
> >> +	ds_release_bts(child);
> >
> >is it right/intentional here?
> 
> The void-cast is intentional in both cases.
> 
> I thought it a question of style, i.e. that we don't want void casts 
> just like we want NULL instead of 0.

ok.

But you could mark ds_release_bts() as a __must_check function, in that 
case the (void) has functional aspects as well: the kernel build will 
complain if a return value is ignored unintentionally.

So i think the code might be fine as-is after all :-/

	Ingo
