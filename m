Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbXBWJge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbXBWJge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 04:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXBWJge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 04:36:34 -0500
Received: from matups.math.u-psud.fr ([129.175.50.4]:56890 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXBWJgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 04:36:33 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH 2/2] usbatm: Detect usb device shutdown and ignore failed urbs.
Date: Fri, 23 Feb 2007 10:36:13 +0100
User-Agent: KMail/1.9.6
Cc: Simon Arlott <254ad70138dc1cdf241hjzcr0007jhhw@thunder.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
References: <45DCBC26.1050308@simon.arlott.org.uk> <200702221143.38809.duncan.sands@math.u-psud.fr> <20070222155318.19b423a9.zaitcev@redhat.com>
In-Reply-To: <20070222155318.19b423a9.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702231036.14048.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On Friday 23 February 2007 00:53:18 Pete Zaitcev wrote:
> On Thu, 22 Feb 2007 11:43:38 +0100, Duncan Sands <duncan.sands@math.u-psud.fr> wrote:
> > > +		/* the module/device has probably been removed */
> > > +		if (urb->status == -ESHUTDOWN)
> > > +			return;
> > > +
> > >  		if (printk_ratelimit())
> > >  			atm_warn(channel->usbatm, "%s: urb 0x%p failed (%d)!\n",
> > >  				__func__, urb, urb->status);
> > 
> > I would rather just suppress the warning in this case, and still do the delayed
> > schedule of the tasklet, in case this error was spurious and we're not really
> > about to be disconnected.
> 
> I disagree. If ESHUTDOWN is received, the endpoint is definitely gone.
> I can see why you might want to retry EPROTO, ELISEQ, etc. but this
> case is different.

if you get ESHUTDOWN, does that mean that you are about to be disconnected,
i.e. the disconnect method is about to be called?  Or is it possible for the
device to just sit there disabled, but not disconnected?

Thanks,

Duncan.
