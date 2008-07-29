Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYG2KSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYG2KSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYG2KSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:18:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:49269 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbYG2KSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PmCu+Xy03QGdRod7wqTLs17lQ+USSqlveWuZm1bsc/8zWFTgBRbuZMFBzmhn+0j9fv
         nTP0J3T64b2VwubjxUM1EDaxZ/N4ImkOaZA3ilPyT7j5aazzGlEXFyyiEc72CAj+VfYO
         luZyRtWcuhrPDt0g7ine5sCAb+2G13GLlO+Z8=
Message-ID: <86802c440807290318j90076fbkf8c66f39cf8af977@mail.gmail.com>
Date: Tue, 29 Jul 2008 03:18:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] x86: printk_time to use tsc before cpu_clock is ready
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1217326387.7563.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807290308.35230.yhlu.kernel@gmail.com>
	 <200807290309.44869.yhlu.kernel@gmail.com>
	 <1217326387.7563.6.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 3:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2008-07-29 at 03:09 -0700, Yinghai Lu wrote:
>> so can get tsc value on printk
>>
>> need to apply after
>>       [PATCH] printk_time: prepare stub for using other than cpu_clock
>
>
> You failed to mention why we want this... ;-)
>

"
otherwise will get
[    0.000000]....
.....
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 2493.378 MHz processor.
[    0.008000] spurious 8259A interrupt: IRQ7.
[    0.008000] Console: colour VGA+ 80x25
[    0.008000] console handover: boot [uart0] -> real [ttyS0]
[    0.008000] Checking aperture...
[    0.008000] No AGP bridge found
[    0.008000] Node 0: aperture @ dc000000 size 64 MB
[    0.008000] Node 1: aperture @ dc000000 size 64 MB
[    0.008000] Node 2: aperture @ dc000000 size 64 MB
[    0.008000] Node 3: aperture @ dc000000 size 64 MB
[    0.008000] Node 4: aperture @ dc000000 size 64 MB
[    0.008000] Node 5: aperture @ dc000000 size 64 MB
[    0.008000] Node 6: aperture @ dc000000 size 64 MB
[    0.008000] Node 7: aperture @ dc000000 size 64 MB
[    0.008000] Memory: 264718324k/269090816k available (7532k kernel
code, 3716316k reserved, 5099k data, 484k init)
[    0.008000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.008000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=32, Nodes=8
[    0.008000] hpet clockevent registered
[    0.008000] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4986.72 BogoMIPS (lpj=9973456)
[    0.060003] Dentry cache hash table entries: 33554432 (order: 16,
268435456 bytes)

with this patch could get tsc to replace those [0,000000] and
[0.0080000], so could debug possible delay on big system on early
stage.
"

YH
