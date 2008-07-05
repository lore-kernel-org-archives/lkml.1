Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbYGEEO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbYGEEO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 00:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYGEEOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 00:14:48 -0400
Received: from [194.117.236.238] ([194.117.236.238]:38823 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGEEOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 00:14:47 -0400
Date: Sat, 5 Jul 2008 07:14:01 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tzanussi@gmail.com, penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
 logging.
Message-ID: <20080705071401.0fe75d9f@linux360.ro>
In-Reply-To: <20080702230636.66e484bb.akpm@linux-foundation.org>
References: <20080623153104.50549291@linux360.ro>
	<20080702230636.66e484bb.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 23:06:36 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
 
> This breaks on sparc64.
> 
> > +			err = smp_call_function_single(i,
> > +
> > __relay_set_buf_dentry,
> > +						       &disp, 0,
> > 1);
> 
> Because that ain't implemented.
> 
> There's a call in net/iucv/iucv.c, but that's s390-only.
> 
> There's a call in virt/kvm/kvm_main.c.
> 
> There's a call in kernel/time/tick-broadcast.c, so I assume that the
> intersection between CONFIG_GENERIC_CLOCKEVENTS_BROADCAST and
> non-smp_call_function_single() architectures is presently empty.

Hi,

I'm not sure what I should do. Maybe disable relay_late_setup_files()
on sparc64, with an empty inline?
 
> I guess all SMP-capable architectures should now implement this,
> please.  It is presently defined on all architectures for CONFIG_SMP=n
> and it is declared in include/linux/smp.h.

sparc64 seems to have smp_call_function_mask(). If we have the generic
kernel/smp.c in linux-next or -mmotm, then this will define
smp_call_function_single() to call smp_call_function_mask().

Is there anything I can do regarding this patch? Does it work since
kernel/smp.c reappeared?


	Eduard
