Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZG2Wkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZG2Wkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 18:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZG2Wku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 18:40:50 -0400
Received: from ru.mvista.com ([213.79.90.228]:29583 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751347AbZG2Wku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 18:40:50 -0400
Date: Thu, 30 Jul 2009 02:40:50 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/7] spi: Add support for device table matching
Message-ID: <20090729224050.GA17902@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
 <20090729170457.GA4803@oksana.dev.rtsoft.ru>
 <20090729214446.GB1728@fluff.org.uk>
 <20090729223223.GA15280@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090729223223.GA15280@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 02:32:23AM +0400, Anton Vorontsov wrote:
> On Wed, Jul 29, 2009 at 10:44:46PM +0100, Ben Dooks wrote:
> [...]
> > > +	const struct spi_device_id *id_table;
> > > +	int			(*probe_id)(struct spi_device *spi,
> > > +					    const struct spi_device_id *id);
> > 
> > how about leaving it at just probe and have either a call or a field
> > in the device that you can look at to see if this was a new style of
> > call?
> 
> There are no technical difficulties with that, but it would be
> inconsitent wrt other "device table"-aware buses (i2c, pci, of).

Btw, I guess there are few reasons why other buses pass id via
probe() call:

- You'll have to store the "id" in device struct forever, while
  in most cases you only need it during probe(), then you don't
  need it at all;

- If you don't store "id" in the device struct, you'll have
  to look up the device table twice (at first during bus->match(),
  and second time in drivers' probe() hook, i.e.
  probe(struct bus_dev *dev) {
  	id = bus_get_devid(dev); /* here */
  }

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
