Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZFSNo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZFSNo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZFSNov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:44:51 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:40146 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZFSNov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:44:51 -0400
Date: Fri, 19 Jun 2009 16:43:32 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux@arm.linux.org.uk
Subject: Re: [PATCH v6] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090619134332.GG21428@tarshish>
References: <1245220477-6904-1-git-send-email-baruch@tkos.co.il> <20090618151916.32d55e6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618151916.32d55e6e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for your review.

On Thu, Jun 18, 2009 at 03:19:16PM -0700, Andrew Morton wrote:
> On Wed, 17 Jun 2009 09:34:37 +0300
> Baruch Siach <baruch@tkos.co.il> wrote:
> > ...
> >
> > +static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
> > +{
> > +	struct pl061_platform_data *pdata;
> > +	struct pl061_gpio *chip;
> > +	struct list_head *chip_list;
> > +	int ret, irq, i;
> > +	static unsigned long init_irq[BITS_TO_LONGS(NR_IRQS)];
> 
> We could perhaps use DECLARE_BITMAP() here.  Which implies that the
> whole use of this bitmap should use the bitmap API rather than
> open-coded bitops.
> 
> I don't know whether that would actually improve anything - it's just a
> thought..

I'll change that.

> > +	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
> > +		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
> > +		if (chip_list == NULL) {
> 
> We should do a clear_bit() here.

Will fix.

Should I post v7 of the entire patch, or just a fix-up for these issues?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
