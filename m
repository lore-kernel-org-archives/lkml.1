Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbZKVNSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbZKVNSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 08:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbZKVNSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 08:18:51 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:56707 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbZKVNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 08:18:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Neg4wKoHUSvR4JtrI/F0tOIEWJGwjvfkfoh7AXOheryemDut3qV0QemVXxv5E1PZsd
         wDCCauXeuEqaRTjZqRcvWN5dlL4d2bLsmtZDwC5HkIuaL7qhkel8R8V3X446ax2m/f1T
         axZ6NlqjDBi+u096rRnZAThfY6HyfXGJeuyYA=
Subject: Re: [PATCH v2] MIPS: Add a high resolution sched_clock() via
 cnt32_to_63().
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>, Michal Simek <monstr@monstr.eu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091122123509.GA1941@linux-mips.org>
References: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com>
	 <20091122081328.GB24558@elte.hu>
	 <1258888086.4548.52.camel@falcon.domain.org>
	 <20091122123509.GA1941@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Sun, 22 Nov 2009 21:18:34 +0800
Message-ID: <1258895914.6913.13.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 12:35 +0000, Ralf Baechle wrote:
> On Sun, Nov 22, 2009 at 07:08:05PM +0800, Wu Zhangjin wrote:
> 
> > > > +	data = (0xffffffffUL / tclk / 2 - 2) * HZ;
> > 
> > Because the MIPS c0 count's frequency is half of the cpu frequency(Hi,
> > Ralf, does every MIPS c0 count meet this feature?), so, the above line
> > should be:
> 
> There are processors which have no cp0 counter at all; these are mostly
> very old pre-R4000 era 32-bit MIPS I and MIPS II cores.
> 
> Of those which have a cp0 counter most will clock it at "half the maximum
> instruction issue rate" and a few at the full rate.  Finally for a few
> such as the RM52xx either half or the full count the rate is selectable by
> the reset initialization bitstream fed into the processor.  Too make this
> feature suck nicely there is no way for software to find out which rate
> was selected so software must know that or calibrate against a timer of
> known frequency.
> 
> Platform-specific code does this by setting mips_hpt_frequency to the
> count rate before calling init_r4k_clocksource; it's also the value being
> passed into setup_sched_clock_update() so you don't need to count for the
> half / full clock rate thing there.
> 
> I don't see why you need the -2 in your formula so the whole thing can
> be simplified to:
> 
> 	data = 0x80000000 / tclk * HZ;
> 

Sorry, I have mixed the mips_hpt_frequency with the cpu frequency,
mips_hpt_frequency is exactly the frequency of the timer. so, there is
no need to consider the relation between it and the cpu frequency here.
therefore, my old formula should be okay, that -2 is used to ensure data
is smaller than half of the period of the timer. 

Best Regards,
	Wu Zhangjin


