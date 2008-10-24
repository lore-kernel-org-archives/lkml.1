Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYJXA2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYJXA2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYJXA2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:28:35 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:54336
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYJXA2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:28:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsBAOyzAEnLrQlq/2dsb2JhbAAIwmmDTg
X-IronPort-AV: E=Sophos;i="4.33,473,1220198400"; 
   d="scan'208";a="407421603"
Subject: Re: [PATCH v2 RESEND] gpiolib: Add pin change notification
From: Ben Nizette <bn@niasdigital.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <20081021133106.be5cc01c.akpm@linux-foundation.org>
References: <1224543007.3954.71.camel@moss.renham>
	 <20081021133106.be5cc01c.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Nias Digital
Date: Fri, 24 Oct 2008 11:28:17 +1100
Message-Id: <1224808097.7082.3.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-10-21 at 13:31 -0700, Andrew Morton wrote:
> On Tue, 21 Oct 2008 09:50:06 +1100
> Ben Nizette <bn@niasdigital.com> wrote:
> > +static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
> > +{
> > +	struct gpio_desc *desc = dev_id;
> > +	int gpio = desc - gpio_desc;
> > +	int new, old;
> > +
> > +	if (!gpio_is_valid(gpio))
> > +		return IRQ_NONE;
> > +
> > +	new = gpio_get_value(gpio);
> > +	old = desc->val;
> > +
> > +	if ((new && !old && test_bit(ASYNC_RISING, &desc->flags)) ||
> > +	    (!new && old && test_bit(ASYNC_FALLING, &desc->flags)))
> > +		sysfs_notify(&desc->dev->kobj, NULL, "value");
> 
> eekeekeek!  sysfs_notify() does mutex_lock() and will die horridly if
> called from an interrupt handler.
> 
> You should have got a storm of warnings when runtime testing this code.
> Please ensure that all debug options are enabled when testing code. 
> Documentation/SubmitChecklist has help.

0_o yea that isn't great...  Thanks - shall respin and repost shortly.


	--Ben.

