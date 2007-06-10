Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXFJLX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXFJLX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 07:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbXFJLXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 07:23:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34698 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbXFJLXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 07:23:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch-mm 06/23] clockevents: Fix resume logic
Date: Sun, 10 Jun 2007 12:58:47 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de> <200706101219.03914.rjw@sisk.pl> <1181471412.384.9.camel@chaos>
In-Reply-To: <1181471412.384.9.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706101258.48721.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 June 2007 12:30, Thomas Gleixner wrote:
> On Sun, 2007-06-10 at 12:19 +0200, Rafael J. Wysocki wrote:
> > > -/*
> > > - * Suspend/resume part
> > > - */
> > > -
> > > -#ifdef CONFIG_PM
> > > -
> > > -static int hpet_suspend(struct sys_device *sys_device, pm_message_t state)
> > > -{
> > > -	unsigned long cfg = hpet_readl(HPET_CFG);
> > > -
> > > -	cfg &= ~(HPET_CFG_ENABLE|HPET_CFG_LEGACY);
> > > -	hpet_writel(cfg, HPET_CFG);
> > > -
> > > -	return 0;
> > > -}
> > 
> > Hmm, I haven't found anything to replace the above in the patch.  Is that
> > intentional, or is it there, but I haven't noticed?
> 
> > > +	case CLOCK_EVT_MODE_RESUME:
> > > +		hpet_enable_int();
> > > +		break;

This is the resume part, or at least it seems so, but the above one is a
suspend callback.  If I understand it correctly, this one replaces
hpet_resume(), but is it sufficient for the suspend part too?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
