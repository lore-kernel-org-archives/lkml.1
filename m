Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbXEaBuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbXEaBuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 21:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXEaBuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 21:50:11 -0400
Received: from omta03ps.mx.bigpond.com ([144.140.82.155]:16469 "EHLO
	omta03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbXEaBuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 21:50:10 -0400
Message-ID: <465E29C4.4010904@bigpond.net.au>
Date: Thu, 31 May 2007 11:49:56 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Con Kolivas <kernel@kolivas.org>, Christoph Lameter <clameter@sgi.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au> <4652DC03.60801@bigpond.net.au> <4655423E.6000202@bigpond.net.au> <20070524164538.GA13301@linux-os.sc.intel.com> <46561E67.3030207@bigpond.net.au> <20070529204557.GB3693@linux-os.sc.intel.com> <465CBD35.2000109@bigpond.net.au> <20070530005052.GE3693@linux-os.sc.intel.com> <465CDEEA.9060507@bigpond.net.au> <20070530044201.GF3693@linux-os.sc.intel.com>
In-Reply-To: <20070530044201.GF3693@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03ps.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Thu, 31 May 2007 01:50:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> On Tue, May 29, 2007 at 07:18:18PM -0700, Peter Williams wrote:
>> Siddha, Suresh B wrote:
>>> I can try 32-bit kernel to check.
>> Don't bother.  I just checked 2.6.22-rc3 and the problem is not present
>> which means something between rc2 and rc3 has fixed the problem.  I hate
>> it when problems (appear to) fix themselves as it usually means they're
>> just hiding.
>>
>> I didn't see any patches between rc2 and rc3 that were likely to have
>> fixed this (but doesn't mean there wasn't one).  I'm wondering whether I
>> should do a git bisect to see if I can find where it got fixed?
>>
>> Could you see if you can reproduce it on 2.6.22-rc2?
> 
> No. Just tried 2.6.22-rc2 64-bit version at runlevel 3 on my remote
> system at office. 15 attempts didn't show the issue.
> 
> Sure that nothing changed in your test setup?
> 
> More experiments tomorrow morning..

I've finished bisecting and the patch at which things appear to improve 
is cd5477911fc9f5cc64678e2b95cdd606c59a11b5 which is in the middle of a 
bunch of patches reorganizing the link phase of the build.  Patch 
description is:

kbuild: add "Section mismatch" warning whitelist for powerpc
author	Li Yang <leoli@freescale.com>
	Mon, 14 May 2007 10:04:28 +0000 (18:04 +0800)
committer	Sam Ravnborg <sam@ravnborg.org>
	Sat, 19 May 2007 07:11:57 +0000 (09:11 +0200)
commit	cd5477911fc9f5cc64678e2b95cdd606c59a11b5
tree	d893f07b0040d36dfc60040dc695384e9afcf103	tree | snapshot
parent	f892b7d480eec809a5dfbd6e65742b3f3155e50e	commit | diff
kbuild: add "Section mismatch" warning whitelist for powerpc

This patch fixes the following class of "Section mismatch" warnings when
building powerpc platforms.

WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to 
.init.data:.got2 from prom_entry (offset 0x0)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference 
to .init.text:mpc8313_rdb_probe from .machine.desc after 
'mach_mpc8313_rdb' (at offset 0x4)
....

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

scripts/mod/modpost.c

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
