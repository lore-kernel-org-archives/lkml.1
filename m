Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbYIJTNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbYIJTNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYIJTNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:13:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48449 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbYIJTNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:13:36 -0400
Date: Wed, 10 Sep 2008 20:13:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Core support for the WM8400 AudioPlus HiFi
	CODEC and PMU
Message-ID: <20080910191335.GA26985@rakim.wolfsonmicro.main>
Mail-Followup-To: Liam Girdwood <lrg@kernel.org>,
	Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
References: <20080910182825.GB16721@rakim.wolfsonmicro.main> <1221071334-19381-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1221072422.17091.253.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221072422.17091.253.camel@odin>
X-Cookie: Whip it, whip it good!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 07:47:01PM +0100, Liam Girdwood wrote:
> On Wed, 2008-09-10 at 19:28 +0100, Mark Brown wrote:

> > +}
> > +EXPORT_SYMBOL_GPL(wm8400_block_read);

> Slight formatting difference with read and block read.  

Erk, yeah.  Will fix.

> > +void wm8400_notify_codec_reset(struct wm8400 *wm8400)
> > +{
> > +	int i;
> > +
> > +	mutex_lock(&wm8400->io_lock);
> > +
> > +	/* Reset all codec registers to their initial value */
> > +	for (i = 0; i < ARRAY_SIZE(wm8400->reg_cache); i++)
> > +		if (reg_data[i].is_codec)
> > +			wm8400->reg_cache[i] = reg_data[i].default_val;
> > +
> > +	mutex_unlock(&wm8400->io_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(wm8400_notify_codec_reset);
> > +

> I would probably rename this since it's really resetting the codec cache
> and not resetting the codec.

The notify in the name was supposed to cover that (implying that it's
notifying the core rather than actually doing the reset) but it's
obviously not doing the job.  I think wm8400_reset_codec_reg_cache()
should be obvious enough?

> Fwiw, I've separated out the different wm8350 functions into separate
> headers - Imho, It just makes it a little easier to read.

Yeah, I considered doing that but decided that it was more trouble than
it was worth - the device has far fewer functions than the WM8350.
