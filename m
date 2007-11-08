Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbXKHKUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbXKHKUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbXKHKUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:20:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:40492 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbXKHKUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:20:21 -0500
From: Andreas Schwab <schwab@suse.de>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, akpm@linux-foundation.org, lkml@davidb.org,
       linux-kernel@vger.kernel.org, drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
References: <20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107161853.044b6e8f.akpm@linux-foundation.org>
	<18226.27701.782268.375231@cargo.ozlabs.ibm.com>
	<20071107.180918.263752219.davem@davemloft.net>
X-Yow: Tex SEX!  The HOME of WHEELS!  The dripping of COFFEE!!  Take me
 to Minnesota but don't EMBARRASS me!!
Date: Thu, 08 Nov 2007 11:20:17 +0100
In-Reply-To: <20071107.180918.263752219.davem@davemloft.net> (David Miller's
	message of "Wed\, 07 Nov 2007 18\:09\:18 -0800 \(PST\)")
Message-ID: <jetznxt4wu.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> I agree with this analysis.
>
> The Linux man page for times() explicitly lists (clock_t) -1 as a
> return value meaning error.
>
> So even if we did make some effort to return errors "properly" (via
> force_successful_syscall_return() et al.) userspace would still be
> screwed because (clock_t) -1 would be interpreted as an error.
>
> Actually I think this basically proves we cannot return (clock_t) -1
> ever because all existing userland (I'm not talking about inside
> glibc, I'm talking about inside of applications) will see this as an
> error.
>
> User applications have no other way to check for error.
>
> This API is definitely very poorly designed, no matter which way we
> "fix" this some case will remain broken.

A possible remedy is to return the ticks since process start time, which
delays the wrap around much further.  POSIX only demands consistency
within the same process.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
