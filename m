Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYLTQI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYLTQI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 11:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYLTQIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 11:08:19 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:24628 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbYLTQIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 11:08:18 -0500
X-Trace: 118555392/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.245/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.245
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.2 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsEAGunTElQLLD1/2dsb2JhbACBbLofWJBthkM
X-IronPort-AV: E=Sophos;i="4.36,255,1228089600"; 
   d="scan'208";a="118555392"
Subject: Re: [PATCH] sh: maple: add support for Maple controller as a
 joystick
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Matt Fleming <matt@console-pimps.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20081220151511.GA6528@console-pimps.org>
References: <1229728542.1441.6.camel@localhost.localdomain>
	 <20081220151511.GA6528@console-pimps.org>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 16:07:27 +0000
Message-Id: <1229789248.6502.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-20 at 15:16 +0000, Matt Fleming wrote:
> On Fri, Dec 19, 2008 at 11:15:42PM +0000, Adrian McMenamin wrote:
> > 
> > Add support for the SEGA Dreamcast Maple controller as a joystick
> > 
> 
> [snip]
> 
> > +	struct dc_pad *pad = maple_get_drvdata(mapledev);
> > +	struct input_dev *dev = pad->dev;
> > +	unsigned char *res = mq->recvbuf;
> > +
> > +	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));
> > +
> 
> I may be wrong but shouldn't this use the I/O accessor functions?
> 

It's not iomemory, so I don't think so. The maple bus writes to a buffer
in the physical RAM.


> > +
> > +	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
> > +	idev = input_allocate_device();
> > +	if (!pad || !idev){
> > +		error = ENOMEM;
> > +		goto fail;
> > +	}
> 
> [snip]
> 
> > +fail:
> > +	input_free_device(pad->dev);
> 
> Possible NULL pointer dereference?

No, because input_free_device is:

void input_free_device(struct input_dev *dev)
{
        if (dev)
               input_put_device(dev);
}
EXPORT_SYMBOL(input_free_device);

