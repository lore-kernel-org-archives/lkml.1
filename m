Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbYEGQXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbYEGQXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbYEGQWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:22:50 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:53945 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbYEGQWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:22:48 -0400
Date: Thu, 08 May 2008 01:23:54 +0900 (JST)
Message-Id: <20080508.012354.82382504.anemo@mba.ocn.ne.jp>
To: dwalker@mvista.com
Cc: tglx@linutronix.de, akpm@linux-foundation.org, johnstul@us.ibm.com,
       ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: shift helper
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1210091954.17132.142.camel@localhost.localdomain>
References: <20080501173123.444094226@mvista.com>
	<alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de>
	<1210091954.17132.142.camel@localhost.localdomain>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 09:39:14 -0700, Daniel Walker <dwalker@mvista.com> wrote:
> > > This is a little helper I pulled from the mips tree.
> > ... 
> > > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> > 
> > And who is the original author of this little helper in the MIPS tree?
> 
> commit 16b7b2ac0148e839da86af8747b6fa4aad43a9b7
> Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

I think Ralf's version is better starting point.

commit 93c846f9047f392fc2335668a5234edfbddb7cdc
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Fri Oct 19 08:13:08 2007 +0100

    [MIPS] time: Helpers to compute clocksource/event shift and mult values.

These helpers are live in arch/mips/kernel/time.c now.

void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
{
	u64 temp;
	u32 shift;

	/* Find a shift value */
	for (shift = 32; shift > 0; shift--) {
		temp = (u64) NSEC_PER_SEC << shift;
		do_div(temp, clock);
		if ((temp >> 32) == 0)
			break;
	}
	cs->shift = shift;
	cs->mult = (u32) temp;
}

BTW, comparing this with clocksource_hz2mult(), inserting

	temp += clock / 2;

to just before do_div() line might be better.

---
Atsushi Nemoto
