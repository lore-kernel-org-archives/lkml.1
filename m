Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbZFBON5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbZFBON5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZFBONu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:13:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55398 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZFBONt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:13:49 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1454M1432R98dR1805M2cdeizz1202hzz5a6ciz32i17ch6bh6di)
X-FB-SS: 5,13,8,
X-WSS-ID: 0KKM7IA-02-JON-01
Date: Tue, 2 Jun 2009 16:13:25 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 29 (__rdmsr_on_cpu() OOPS)
Message-ID: <20090602141325.GB13792@aftab>
References: <20090529145018.ff547ea1.sfr@canb.auug.org.au> <200905302137.57644.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200905302137.57644.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 02 Jun 2009 14:13:25.0816 (UTC) FILETIME=[4B7CB380:01C9E38C]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 30, 2009 at 09:37:57PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> next-20090529 oopses in __rdmsr_on_cpu() on my Pentium M laptop.
> 
> .jpg + .config:
> http://www.kernel.org/pub/linux/kernel/people/bart/next-20090529-oops.*
> 
> (gdb) l *0xc023410f
> 0xc023410f is in __rdmsr_on_cpu (arch/x86/lib/msr.c:25).
> 20              if (rv->msrs)
> 21                      reg = &rv->msrs[this_cpu - rv->off];
> 22              else
> 23                      reg = &rv->reg;
> 24
> 25              rdmsr(rv->msr_no, reg->l, reg->h);
> 26      }
> 27
> 28      static void __wrmsr_on_cpu(void *info)
> 29      {
> 
> Thus the problem seems to be introduced by:
> 
> commit 23d19840368b2787d2da97ad0f0f29248503648a
> Author: Borislav Petkov <borislav.petkov@amd.com>
> Date:   Fri May 22 13:52:19 2009 +0200
> 
>     x86: MSR: add methods for writing of an MSR on several CPUs
> ...
> 
> and indeed the following patch fixes it:
> 
> [ Borislav, feel free to fold it into the above change or replace by
>   a more complete one if needed (there may be more rv fields needing
>   initialization). ]
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] x86: MSR: fix __rdmsr_on_cpu() OOPS
> 
> {rd,wr}msr_on_cpu() need to explicitly initalize rv.msrs
> (since rv is allocated on the stack).
> 
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Thanks.

I went and zeroed out the whole struct so that no stale data sneaks
in. I'm still adding your S-O-B to the patch, if you don't mind, that
is.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

