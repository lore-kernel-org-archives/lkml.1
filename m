Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZJMADb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZJMADb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZJMADb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:03:31 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:48499 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZJMADa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:03:30 -0400
Date: Tue, 13 Oct 2009 02:02:46 +0200
From: Daniel Mack <daniel@caiaq.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [spi-devel-general] [PATCH] drivers/misc: add driver for
 TexasInstruments DAC7512
Message-ID: <20091013000245.GE28832@buzzloop.caiaq.de>
References: <1254945665-28053-1-git-send-email-daniel@caiaq.de>
 <BD79186B4FD85F4B8E60E381CAEE190901DB7EF3@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901DB7EF3@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 12:31:46PM -0400, H Hartley Sweeten wrote:
> On Wednesday, October 07, 2009 1:01 PM, Daniel Mack wrote:
> > This is actually too trivial to publish, but to export the function of
> > that chip to the userspace, a module like this is needed.
> > 
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Brownell <dbrownell@users.sourceforge.net>
> > Cc: spi-devel-general@lists.sourceforge.net
> > ---
> 
> [snip]
> 
> > +static ssize_t dac7512_store_val(struct device *dev,
> > +				 struct device_attribute *attr,
> > +				 const char *buf, size_t count)
> > +{
> > +	struct spi_device *spi = to_spi_device(dev);
> > +	unsigned char tmp[2];
> > +	unsigned long val;
> > +
> > +	if (strict_strtoul(buf, 10, &val) < 0)
> > +		return -EINVAL;
> > +
> > +	tmp[0] = val >> 8;
> > +	tmp[1] = val & 0xff;
> > +	spi_write(spi, tmp, sizeof(tmp));
> > +	return count;
> > +}
> > +
> > +static DEVICE_ATTR(value, S_IWUSR | S_IRUGO,
> > +		   NULL, dac7512_store_val);
> 
> You have declared the "value" device attribute with mode S_IWUSR | S_IRUGO
> but have not provided a show callback.

That's true, and acutally on purpose. I would have needed a private data
structure to allocate which I didn't do because I didn't need that. The
approach is purely write-only, especially beacuse the hardware also does
not provide a way to read back the current value.

Daniel
