Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbYEPWOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbYEPWOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYEPWO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:14:26 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:44011 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbYEPWOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:14:24 -0400
Message-ID: <fa686aa40805161514r513d0eebt380a76f64abe8434@mail.gmail.com>
Date: Fri, 16 May 2008 16:14:23 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: cbouatmailru@gmail.com
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com
In-Reply-To: <20080516220338.GA3255@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
	 <20080516220338.GA3255@zarina>
X-Google-Sender-Auth: bffc067c1fff41ab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 4:03 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Fri, May 16, 2008 at 01:36:13PM -0600, Grant Likely wrote:
>> +             /* Store a pointer to the node in the device structure */
>> +             of_node_get(nc);
>> +             spi->dev.archdata.of_node = nc;
>> +
>> +             /* Register the new device */
>> +             rc = spi_register_device(spi);
>> +             if (rc) {
>> +                     dev_err(&master->dev, "spi_device register error %s\n",
>> +                             np->full_name);
>> +                     spi_device_release(spi);
>> +             }
>
> No way to pass platform data... can you suggest any idea to use
> this for things like
> "[POWERPC] 86xx: mpc8610_hpcd: add support for SPI and MMC-over-SPI"
> I've sent just recently...?

That's right.  platform_data being a very driver specific thing there
is no way to generically extract a pdata structure from the device
tree.  Instead, I'm storing the device node in archdata.of_node (line
immediately above spi_register_device) so that drivers can read the
device node themselves to populate a platform_device structure.
(Protected by CONFIG_OF of course).

> Maybe this code could do something like
> spi->dev.platform_data = nc->data;
> and board code would fill nc->data at early stages? This needs to be a
> convention, not just random use though.. Maybe we can expand the struct
> device_node to explicitly include .platform_data for such cases?

Hmmm, as you say, this could end up being rather messy.  However, by
passing the device node pointer, the driver could extract that data on
a per case basis.  (ie. it would be decided on a per driver basis
where to get the platform data).  I'm not sure; this bears more
thought...

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
