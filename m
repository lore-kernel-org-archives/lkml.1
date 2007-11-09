Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbXKISVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbXKISVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXKISVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:21:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbXKISU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:20:59 -0500
Message-ID: <4734A4D9.3090907@redhat.com>
Date: Fri, 09 Nov 2007 10:20:09 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Andreas Schwab <schwab@suse.de>, David Miller <davem@davemloft.net>,
       paulus@samba.org, akpm@linux-foundation.org, lkml@davidb.org,
       linux-kernel@vger.kernel.org, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
References: <20071107152833.6f302c2a.akpm@linux-foundation.org> <20071107161853.044b6e8f.akpm@linux-foundation.org> <18226.27701.782268.375231@cargo.ozlabs.ibm.com> <20071107.180918.263752219.davem@davemloft.net> <jetznxt4wu.fsf@sykes.suse.de> <4733206C.8030903@nortel.com>
In-Reply-To: <4733206C.8030903@nortel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Friesen wrote:
>> A possible remedy is to return the ticks since process start time, which
>> delays the wrap around much further.  POSIX only demands consistency
>> within the same process.
> 
> This would be an interesting solution.
> 
> The man page for linux states that the return code is time since system
> boot, so that could realistically be expected to correlate between
> different processes.

The Linux man page is documenting existing functionality on top of what
the standard requires.  Programmers should ever only require what the
standard guarantees.

I am perfectly willing to support a solution where the time is measured
from process startup time.  The only code using times() I found is
cross-platform and most likely does not depend on the value returned is
usable in isolation (only in a difference).

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHNKTZ2ijCOnn/RHQRAv2wAJsHOnWRrbE2N2Z4R35bsU1+BIZEGQCguaxL
zY9f4XEhJnAoNF5jFxm76qI=
=0nsU
-----END PGP SIGNATURE-----
