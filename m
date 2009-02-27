Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbZB0Uj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbZB0Uj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759495AbZB0Uh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:37:28 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:57315 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760740AbZB0Uh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:37:26 -0500
Date: Fri, 27 Feb 2009 22:37:18 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dbrownell@users.sourceforge.net, dmitry.torokhov@gmail.com,
       sameo@openedhand.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Message-ID: <20090227203717.GL16801@frodo>
Reply-To: me@felipebalbi.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090227123344.33196e99.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227123344.33196e99.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 12:33:44PM -0800, Andrew Morton wrote:
> On Fri, 27 Feb 2009 21:28:02 +0200
> Felipe Balbi <me@felipebalbi.com> wrote:
> 
> > +static irqreturn_t powerbutton_irq(int irq, void *dev_id)
> > +{
> > +	int err;
> > +	u8 value;
> > +
> > +#ifdef CONFIG_LOCKDEP
> > +	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> > +	 * we don't want and can't tolerate.  Although it might be
> > +	 * friendlier not to borrow this thread context...
> > +	 */
> > +	local_irq_enable();
> > +#endif
> > +
> > +	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
> > +				  STS_HW_CONDITIONS);
> > +	if (!err)  {
> > +		input_report_key(powerbutton_dev, KEY_POWER,
> > +				 value & PWR_PWRON_IRQ);
> > +	} else {
> > +		dev_err(dbg_dev, "twl4030: i2c error %d while reading TWL4030"
> > +			" PM_MASTER STS_HW_CONDITIONS register\n", err);
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> 
> Tell us some more about this lockdep thing ;)

David Brownell can comment better about it, that came from him when we
were converting twl4030 driver(s) to a more readable form :-)

If you take a look at all twl4030's children, you'll all of them needed
that.

Dave, could you comment, please ?

-- 
balbi
