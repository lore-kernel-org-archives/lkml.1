Return-Path: <linux-kernel-owner+w=401wt.eu-S1761669AbZATAZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669AbZATAZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764091AbZATAZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:25:21 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:7817 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763015AbZATAZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:25:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U2SiD+VjxK/3EQ5fSSOaiPkqOTcgvitbKWvjORwCpbYEw907npPDi03zXDYVAjIYqj
         ppV4NlYKAATXXWy47NQfdvu9oGNPaWCWox0BrUVFWdhsHagHesZxYQYpBKgZjbTwAd7M
         UD5kKgLE3GYwV+lv/PseLM11sd0vrv+gnfUSM=
MIME-Version: 1.0
In-Reply-To: <497322CC.7050900@cfl.rr.com>
References: <497322CC.7050900@cfl.rr.com>
Date: Mon, 19 Jan 2009 16:25:16 -0800
X-Google-Sender-Auth: 772dd5895a271fc0
Message-ID: <1f1b08da0901191625i6ac12312g9ae9ab599958a818@mail.gmail.com>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II 
	processor
From: john stultz <johnstul@us.ibm.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Hounschell <markh@compro.net>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 4:38 AM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> I upgraded from a Phenom to a Phenom-II processor and I could no longer boot.
>
> I have tried kernels from 2.6.26 through 2.6.28.
>
> I _can_ however boot these kernels when they are configured for HZ = 250. I
> haven't tried HZ = 300. But certainly if HZ = 1000 the boot hangs at the spot
> indicated below in the dmesg output.
>
> The machine is up and stable running 2.6.26.8 with a (HZ = 1000) configured kernel.
>
> While running a 2.6.26.8 kernel configured for HZ = 250:
[snip]
>    vmalloc : 0xf4800000 - 0xff7fe000   ( 175 MB)
>    lowmem  : 0xc0000000 - 0xf4000000   ( 832 MB)
>      .init : 0xc0373000 - 0xc03a9000   ( 216 kB)
>      .data : 0xc02b5336 - 0xc036c6d0   ( 732 kB)
>      .text : 0xc0100000 - 0xc02b5336   (1748 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
>
>
>      The 2.6.26.8 kernel hangs up right here.
>
>
> CPA: page pool initialized 1 of 1 pages preallocated
> SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> hpet clockevent registered
> calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.

This looks suspect. Probably something is off with the timer
interrupt, that's causing the calibration to be way off.

Does booting with hpet=disable change anything?

thanks
-john
