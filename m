Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbXFJKaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbXFJKaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 06:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXFJKaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 06:30:15 -0400
Received: from www.osadl.org ([213.239.205.134]:51189 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752141AbXFJKaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 06:30:14 -0400
Subject: Re: [patch-mm 06/23] clockevents: Fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <200706101219.03914.rjw@sisk.pl>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <20070610092446.588014600@inhelltoy.tec.linutronix.de>
	 <200706101219.03914.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 10 Jun 2007 12:30:12 +0200
Message-Id: <1181471412.384.9.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-10 at 12:19 +0200, Rafael J. Wysocki wrote:
> > -/*
> > - * Suspend/resume part
> > - */
> > -
> > -#ifdef CONFIG_PM
> > -
> > -static int hpet_suspend(struct sys_device *sys_device, pm_message_t state)
> > -{
> > -	unsigned long cfg = hpet_readl(HPET_CFG);
> > -
> > -	cfg &= ~(HPET_CFG_ENABLE|HPET_CFG_LEGACY);
> > -	hpet_writel(cfg, HPET_CFG);
> > -
> > -	return 0;
> > -}
> 
> Hmm, I haven't found anything to replace the above in the patch.  Is that
> intentional, or is it there, but I haven't noticed?

> > +	case CLOCK_EVT_MODE_RESUME:
> > +		hpet_enable_int();
> > +		break;

	tglx


