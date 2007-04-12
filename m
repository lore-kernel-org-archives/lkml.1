Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXDLOVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXDLOVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbXDLOVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:21:07 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56611 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbXDLOVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:21:05 -0400
Date: Thu, 12 Apr 2007 18:20:23 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 5/7] [RFC] ds2760 W1 slave
Message-ID: <20070412142023.GA18134@2ka.mipt.ru>
References: <20070411232517.GE20095@zarina> <20070412070854.GA32440@2ka.mipt.ru> <20070412140807.GA25532@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070412140807.GA25532@zarina>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 12 Apr 2007 18:20:49 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 06:08:07PM +0400, Anton Vorontsov (cbou@mail.ru) wrote:
> > > +int w1_ds2760_read(struct device *dev, char *buf, int addr, size_t count)
> > > +{
> > > +	return w1_ds2760_io(dev, buf, addr, count, 0);
> > > +}
> > > +
> > > +int w1_ds2760_write(struct device *dev, char *buf, int addr, size_t count)
> > > +{
> > > +	return w1_ds2760_io(dev, buf, addr, count, 1);
> > > +}
> > 
> > Both are exported, who use them?
> 
> ds2760_battery driver. W1 does not have any API to "talk" to w1 slaves
> in generic manner (at least I didn't found any).
> So, ds2760_battery using it.

It was - bus masters were accessed through generic find_bus() via
device/driver model, bus master has links to all devices found on
controlled bus.
But find_bus() was removed, so there is no such mechanism right now.

I have no objections against this driver, feel free to add my ack (when
trivialities described are resolved) or I can push w1 part myself.

-- 
	Evgeniy Polyakov
