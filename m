Return-Path: <linux-kernel-owner+w=401wt.eu-S965410AbXIGONb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410AbXIGONb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXIGONY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:13:24 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:37334 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965380AbXIGONX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:13:23 -0400
Date: Fri, 7 Sep 2007 10:13:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Subject: Re: [patch 06/10] Text Edit Lock - kprobes architecture independent support
Message-ID: <20070907141321.GG9735@Krystal>
References: <20070906200124.595238505@polymtl.ca> <20070906200212.399420921@polymtl.ca> <20070907102805.GA10389@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070907102805.GA10389@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:13:10 up 39 days, 14:32,  4 users,  load average: 0.09, 0.39, 0.46
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli (ananth@in.ibm.com) wrote:
> On Thu, Sep 06, 2007 at 04:01:30PM -0400, Mathieu Desnoyers wrote:
> 
> <snip>
> 
> > @@ -716,8 +720,9 @@ static int __kprobes pre_handler_kretpro
> >  				 struct kretprobe_instance, uflist);
> >  		ri->rp = rp;
> >  		ri->task = current;
> > +		kernel_text_lock();
> >  		arch_prepare_kretprobe(ri, regs);
> > -
> > +		kernel_text_unlock();
> 
> pre_handler_kretprobe() is run when the entry probe for a retprobed
> function is hit and cannot block. You can't take a mutex here.
> 
> And why do we need to take the kernel_text_lock() here anyway? All
> arch_prepare_kretprobe() does is modify the return address stored either
> on stack or a register (arch specific) to the trampoline. We don't
> change any kernel text here.
> 

Yep, good catch. Fixing.

> Ananth

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
