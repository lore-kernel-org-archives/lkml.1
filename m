Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZB0Ues@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZB0Ues (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbZB0UeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:34:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756747AbZB0UeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:34:19 -0500
Date: Fri, 27 Feb 2009 12:33:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dbrownell@users.sourceforge.net,
       dmitry.torokhov@gmail.com, sameo@openedhand.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Message-Id: <20090227123344.33196e99.akpm@linux-foundation.org>
In-Reply-To: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 21:28:02 +0200
Felipe Balbi <me@felipebalbi.com> wrote:

> +static irqreturn_t powerbutton_irq(int irq, void *dev_id)
> +{
> +	int err;
> +	u8 value;
> +
> +#ifdef CONFIG_LOCKDEP
> +	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> +	 * we don't want and can't tolerate.  Although it might be
> +	 * friendlier not to borrow this thread context...
> +	 */
> +	local_irq_enable();
> +#endif
> +
> +	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
> +				  STS_HW_CONDITIONS);
> +	if (!err)  {
> +		input_report_key(powerbutton_dev, KEY_POWER,
> +				 value & PWR_PWRON_IRQ);
> +	} else {
> +		dev_err(dbg_dev, "twl4030: i2c error %d while reading TWL4030"
> +			" PM_MASTER STS_HW_CONDITIONS register\n", err);
> +	}
> +
> +	return IRQ_HANDLED;
> +}

Tell us some more about this lockdep thing ;)
