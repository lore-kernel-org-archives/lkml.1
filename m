Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbXBVXzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbXBVXzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 18:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXBVXzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 18:55:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbXBVXy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 18:54:59 -0500
Date: Thu, 22 Feb 2007 15:53:18 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: Simon Arlott <254ad70138dc1cdf241hjzcr0007jhhw@thunder.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zaitcev@redhat.com, linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] usbatm: Detect usb device shutdown and ignore
 failed urbs.
Message-Id: <20070222155318.19b423a9.zaitcev@redhat.com>
In-Reply-To: <200702221143.38809.duncan.sands@math.u-psud.fr>
References: <45DCBC26.1050308@simon.arlott.org.uk>
	<200702221143.38809.duncan.sands@math.u-psud.fr>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 11:43:38 +0100, Duncan Sands <duncan.sands@math.u-psud.fr> wrote:

> > +		/* the module/device has probably been removed */
> > +		if (urb->status == -ESHUTDOWN)
> > +			return;
> > +
> >  		if (printk_ratelimit())
> >  			atm_warn(channel->usbatm, "%s: urb 0x%p failed (%d)!\n",
> >  				__func__, urb, urb->status);
> 
> I would rather just suppress the warning in this case, and still do the delayed
> schedule of the tasklet, in case this error was spurious and we're not really
> about to be disconnected.

I disagree. If ESHUTDOWN is received, the endpoint is definitely gone.
I can see why you might want to retry EPROTO, ELISEQ, etc. but this
case is different.

-- Pete
