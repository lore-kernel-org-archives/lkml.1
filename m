Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbZBKUOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbZBKUOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbZBKUNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:13:55 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:49594 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbZBKUNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:13:54 -0500
X-Greylist: delayed 2537 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 15:13:54 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwEAN+/kklMQWt2/2dsb2JhbACBbtNdhBsG
Date: Wed, 11 Feb 2009 15:13:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.28.4 freezing on a 32-bits x86 Thinkpad T43p
Message-ID: <20090211201349.GB32122@Krystal>
References: <20090204211106.GA30824@Krystal> <20090204211759.GK22608@elte.hu> <20090211193125.GA30975@Krystal> <20090211195038.GC25968@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090211195038.GC25968@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:09:58 up 41 days, 20:08,  4 users,  load average: 1.56, 0.55,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Here is a new backtrace, taken with a huge amount of debugging active, which still 
> > points to an interrupt handler nested over kvm_mmu_pte_write as the culprit. It's 
> > weird that the kvm code gets called on my modest Pentium M laptop, which I think 
> > has no VT-x support at all. I am not running any KVM VMs on this machine. The 
> > problem still happens on 2.6.28.4, and Slub redzones did not identify any memory 
> > corruption. This could be due to kvm_mmu_pte_write which either should not be 
> > called at all, or due to improper interrupt disabling in this function.
> 
> Does latest tip:master fix it? In particular this one:
> 
>   9cf161a: x86/cpa: make sure cpa is safe to call in lazy mmu mode
> 
> fixes a crasher related to KVM and mmu notifiers ...
> 
> 	Ingo

I'll try to apply commit 
9cf161a: x86/cpa: make sure cpa is safe to call in lazy mmu mode

To my 2.6.28.4 kernel to change the configuration minimally and see if
it helps. I guess we'll have to wait a few days before the problem is
reproduced, and even more if it's not. :)

Thanks a lot!

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
