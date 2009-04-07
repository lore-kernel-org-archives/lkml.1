Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZDGMt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZDGMt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZDGMtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:49:18 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:55220 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZDGMtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:49:18 -0400
Date: Tue, 07 Apr 2009 21:49:23 +0900 (JST)
Message-Id: <20090407.214923.126142447.anemo@mba.ocn.ne.jp>
To: peterz@infradead.org
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] rtc-ds1553: Drop IRQF_DISABLED
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1239046422.798.4803.camel@twins>
References: <1239036633-10032-2-git-send-email-anemo@mba.ocn.ne.jp>
	<1239046422.798.4803.camel@twins>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Apr 2009 21:33:42 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> > IRQF_DISABLED should be be used with IRQF_SHARED.  Drop IRQF_DISABLED
> > and add spin_lock_irqsave/spin_unlock_irqrestore to the interrupt
> > handler.
> 
> I think you should use IRQF_DISABLED if at all possible. Only broken
> hardware has an excuse not to.
> 
> NAK

OK, then I will drop IRQF_SHARED instead.  There is no in-tree user of
this driver and only out-of-tree user I know uses dedicated irq line
for this RTC.

---
Atsushi Nemoto
