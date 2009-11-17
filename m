Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZKQOPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZKQOPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZKQOPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:15:30 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:40526 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbZKQOP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:15:28 -0500
Message-ID: <4B02AD9B.5040105@msgid.tls.msk.ru>
Date: Tue, 17 Nov 2009 17:05:15 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Lee Merrill <lee_merrill@yahoo.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Jiffies jumping with the x86 HPET
References: <768725.48321.qm@web53403.mail.re2.yahoo.com>
In-Reply-To: <768725.48321.qm@web53403.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Merrill wrote:
> We are seeing jiffies go forward occasionally, by 300 seconds, this it appears is due to the following code in the 2.6.16 kernel:
> 
> mark_offset_tsc_hpet(void):
> ...
> 1       hpet_current = hpet_readl(HPET_COUNTER);
> 2       rdtsc(last_tsc_low, last_tsc_high);
> 3
> 4       /* lost tick compensation */
> 5       offset = hpet_readl(HPET_T0_CMP) - hpet_tick;
> 6       if (unlikely(((offset - hpet_last) > hpet_tick) && (hpet_last != 0))
> 7                                       && detect_lost_ticks) {
> 8               int lost_ticks = (offset - hpet_last) / hpet_tick;
> 9               jiffies_64 += lost_ticks;
> 10      }
> 11      hpet_last = hpet_current;

There is no such code in current (2.6.31 or even 2.6.27.y) kernel.
Both hpet support and timer/clock code received huge changes in
2.6.24+ kernels.  I guess your best bet is to upgrade.

/mjt
