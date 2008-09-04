Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYIDPR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYIDPR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYIDPRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:17:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbYIDPRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:17:47 -0400
Message-ID: <48BFFAFB.6060907@zytor.com>
Date: Thu, 04 Sep 2008 08:12:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Prarit Bhargava <prarit@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, arozansk@redhat.com, dzickus@redhat.com,
       Thomas.Mingarelli@hp.com, ak@linux.intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com> <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com> <20080904145617.GB28095@elte.hu>
In-Reply-To: <20080904145617.GB28095@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> i'd much rather attack this general problem from this angle:
> 
>   static inline unsigned char get_nmi_reason(void)
>   {
>           return inb(0x61);
>   }
> 
> that port 61H read is both arcane (on modern chipsets) and broken on 
> multiple levels. It's racy and SMP unsafe to begin with, if there's any 
> mixture of intentional cross-CPU or CPU self-generated NMIs mixed with 
> chipset generated NMIs.
> 
> One possible approach would be to get rid of it, and to perhaps register 
> a low-priority die notifier on systems where we know port 61 
> reads+writes to be safe and desired. Modern systems will emit MCEs in 
> most cases anyway, not NMIs.
> 

I believe we should still do it, but as the lowest priority "nothing 
else claimed this".  It reflects a system error and not all systems will 
generate #MC instead of NMI for all system errors.

Pretty much what you're saying above.

	-hpa
