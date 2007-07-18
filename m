Return-Path: <linux-kernel-owner+w=401wt.eu-S936104AbXGRSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936104AbXGRSSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935823AbXGRSSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:18:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46962 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935799AbXGRSSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:18:31 -0400
Date: Wed, 18 Jul 2007 20:18:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, caglar@pardus.org.tr, andi@firstfloor.org
Subject: Re: [PATCH] i386: Decouple PAE from CONFIG_CMPXCHG64
Message-ID: <20070718181829.GA3848@one.firstfloor.org>
References: <11847764879-git-send-email-avi@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11847764879-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 07:34:47PM +0300, Avi Kivity wrote:
> Commit 9d9bbd4d247a674deb43565582151acdc22e90d1 makes CONFIG_CMPXCHG64
> dependent on CONFIG_HIGHMEM64G, but KVM guest SMP support now also
> requires CMPXCHG64 while not being tied to PAE.  So the effect of that patch
> is to disable KVM on non-PAE configs.
> 
> Untangle those dependencies by:
>  - having KVM select CMPXCHG64
>  - having HIGHMEM64G select CMPXCHG64_REQUIRED, a variant that also
>    checks for the feature at early boot
> 
> No processors that support KVM exist that also do not support CMPXCHG64,
> so no additional check is necessary.  This setup allows for a single kernel
> that will boot on i486 and also support KVM if available.

The CONFIG should only control the early CPUID checks, which are needed for PAE
kernels.

But for something late like KVM the correct fix is really to drop
the ifdefs around the macro and check boot_cpu_has() yourself.

-Andi
