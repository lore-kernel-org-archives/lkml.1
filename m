Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYH3Og6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYH3Og6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYH3Ogr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:36:47 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:51295 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbYH3Ogq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:36:46 -0400
Date: Sat, 30 Aug 2008 23:36:47 +0900 (JST)
Message-Id: <20080830.233647.05599714.anemo@mba.ocn.ne.jp>
To: alan@lxorguk.ukuu.org.uk
Cc: david@fries.net, linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ne.c msleep not mdelay
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080830095906.6cad8647@lxorguk.ukuu.org.uk>
References: <20080830024453.GB24929@spacedout.fries.net>
	<20080830095906.6cad8647@lxorguk.ukuu.org.uk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 09:59:06 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > mdelay(10) replaced by msleep(10) to give up the CPU, it's just
> > waiting for an interrupt, so timing isn't critical.
> 
> It is too critical for a reschedule to occur.
> 
> NAK this one.

There are already some msleep() in probe_irq_on() which is called just
before here.  And this part is not protected by any spinlock or
preempt_disable.

So, if rescheduling was dangerous here, we already have potential
problems, no?

---
Atsushi Nemoto
