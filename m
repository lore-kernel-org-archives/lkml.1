Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbXENX1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbXENX1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXENX1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:27:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:34277 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXENX1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:27:15 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] Let smp_call_function_single return -EBUSY.
Date: Tue, 15 May 2007 01:24:40 +0200
User-Agent: KMail/1.9.1
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, randy.dunlap@oracle.com, paulus@samba.org,
       benh@kernel.crashing.org, David Miller <davem@davemloft.net>
References: <20070514092317.GB8968@osiris.boeblingen.de.ibm.com> <20070514121137.ddcc3f5a.akpm@linux-foundation.org>
In-Reply-To: <20070514121137.ddcc3f5a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705150124.41486.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 21:11, Andrew Morton wrote:
> On Mon, 14 May 2007 11:23:17 +0200
>
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> >
> > All architectures that have an implementation of smp_call_function_single
> > let it return -EBUSY if it is asked to execute func on the current cpu.
> > Therefore the UP version must always return -EBUSY.
>
> smp_call_function_single() is a mess.
>
> - it's unclear to me why smp_call_function_single(cpu, ...) doesn't just
>   call the darn function if cpu==smp_processor_id().

I always wondered that too.

Also I think we really need a cpu notifier that does smp_call_single 
automatically; i  find myself reimplementing that multiple times.

> - it's unclear to me why smp_call_function_single(cpu, ...) doesn't just
>   call the darn function if CONFIG_SMP=n.

Yes.

>
> - it's unclear to me why smp_call_function_single(cpu, ...) isn't called
>   smp_call_function_on(cpu, ...)
>
> - the x86_64 version doesn't return -EBUSY: it returns zero.  Despite its
>   claim "Retrurns 0 on success, else a negative status code.".

Will fix.

-Andi
