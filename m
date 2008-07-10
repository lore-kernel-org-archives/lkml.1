Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYGJKaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYGJKaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYGJKao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:30:44 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:12512 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYGJKao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:30:44 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-164.messagelabs.com!1215685843!26828935!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Thu, 10 Jul 2008 12:30:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Message-ID: <20080710103036.GA32507@digi.com>
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se> <20080710065639.GA16794@digi.com> <20080710094641.0c52eaa7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080710094641.0c52eaa7@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Jul 2008 10:30:40.0065 (UTC) FILETIME=[FFCCB310:01C8E277]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 
> > > +       else if (!irq_on && !priv->irq_disabled)
> > > +               disable_irq(dev_info->irq);
> > I'm not sure if this is a problem on SMP.  Should you use
> > disable_irq_nosync here, too?  Probably it's OK.
> 
> That one will also deadlock.
Can you explain why?  I think irqcontrol is only called in task context.
I only see one possible deadlock and that's disable_irq being called
while the irq is IRQ_INPROGRESS on the same cpu.  I'm always willing to
learn.

> The easiest fix is probably to use test_and_set and friends for each I/O
> operation.
Actually using spinlock + irq_disabled variable is new in V2 of this
patch.  Don't know why this changed, though.

>            You would then not need the lock to protect ->irq_disabled.
> Propogating that throughout means your user space has to handle the case
> of an IRQ arriving after disable returns but would be a fair bit saner I
> think ?
I think I didn't understand you right here, with the lock this can
happen, too, doesn't it?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
