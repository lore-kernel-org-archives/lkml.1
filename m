Return-Path: <linux-kernel-owner+w=401wt.eu-S933035AbZHEBNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbZHEBNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbZHEBNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:13:02 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:44460 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932796AbZHEBNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:13:01 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2009 21:13:00 EDT
Date: Wed, 5 Aug 2009 05:06:20 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Ben Dooks <ben-linux@fluff.org>, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/7] spi: Add support for device table matching
Message-ID: <20090805010620.GB14451@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
 <20090729170457.GA4803@oksana.dev.rtsoft.ru>
 <20090729214446.GB1728@fluff.org.uk>
 <200908031921.23126.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200908031921.23126.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 07:21:22PM -0700, David Brownell wrote:
> On Wednesday 29 July 2009, Ben Dooks wrote:
> > >  struct spi_driver {
> > > +     const struct spi_device_id *id_table;
> > > +     int                     (*probe_id)(struct spi_device *spi,
> > > +                                         const struct spi_device_id *id);
> > 
> > how about leaving it at just probe and have either a call or a field
> > in the device that you can look at to see if this was a new style of
> > call?
> > 
> > >       int                     (*probe)(struct spi_device *spi);
> 
> For the record, if this is going to happen I think the
> appropriate long-term solution is to have probe() take
> the device_id just as it does with other busses.

Just curious. Why you prefer another argument in the probe()
instead of calling some helper function? Most drivers don't
need the "id" argument, so why spend memory and cpu cycles
for it?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
