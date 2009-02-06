Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZBFNwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZBFNwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZBFNwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:52:17 -0500
Received: from mga05.intel.com ([192.55.52.89]:23990 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997AbZBFNwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:52:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="663431260"
Date: Fri, 6 Feb 2009 14:54:32 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Support active high IRQs on WM835x
Message-ID: <20090206135431.GA3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1232997799-18943-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20090202135650.838a3ddd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202135650.838a3ddd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Feb 02, 2009 at 01:56:50PM -0800, Andrew Morton wrote:
> On Mon, 26 Jan 2009 19:23:18 +0000
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> >  drivers/mfd/wm8350-core.c       |   16 +++++++++++++++-
> >  include/linux/mfd/wm8350/core.h |    2 ++
> >  2 files changed, 17 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> > index e5e82c7..908284c 100644
> > --- a/drivers/mfd/wm8350-core.c
> > +++ b/drivers/mfd/wm8350-core.c
> > @@ -1423,7 +1423,21 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
> >  	mutex_init(&wm8350->irq_mutex);
> >  	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
> >  	if (irq) {
> > -		ret = request_irq(irq, wm8350_irq, 0,
> > +		int flags = 0;
> > +
> > +		if (pdata && pdata->irq_high) {
> > +			flags |= IRQF_TRIGGER_HIGH;
> > +
> > +			wm8350_set_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
> > +					WM8350_IRQ_POL);
> > +		} else {
> > +			flags |= IRQF_TRIGGER_LOW;
> > +
> > +			wm8350_clear_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
> > +					  WM8350_IRQ_POL);
> > +		}
> > +
> > +		ret = request_irq(irq, wm8350_irq, flags,
> >  				  "wm8350", wm8350);
> >  		if (ret != 0) {
> >  			dev_err(wm8350->dev, "Failed to request IRQ: %d\n",
> 
> This conflicts a bit with your earlier
> mfd-initialise-wm8350-interrupts-earlier.patch.
> 
> I had marked mfd-initialise-wm8350-interrupts-earlier.patch as
> needed-in-2.6.29 so I reworked this patch to fit.
> 
> afacit we haven't heard from Sam in a couple of weeks.  If he's having
> a bit of downtime I guess I'll merge
Sorry for the latency. Our mailserver had some issues, and I was quite busy
fixing wireless drivers myself :/
I'm back on track now. Mark, I havent got those 2 mfd patches. Did you send
them to me for merging ? If that's so, could you please resend them ?

Cheers,
Samuel.


> mfd-initialise-wm8350-interrupts-earlier.patch
> mfd-mark-wm835x-usb_slv_500ma-bit-as-accessible.patch
> mfd-pcf50633-terminate-i2c_device_id-list.patch
> 
> myself.  But I'll leave that a week or two yet.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
