Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYILQjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYILQjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 12:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYILQjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 12:39:25 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:64585 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752904AbYILQjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 12:39:24 -0400
Date: Fri, 12 Sep 2008 17:35:35 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: vidhumouli hunsigida <hv_mouli@yahoo.com>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: Supporting new features in I2C
Message-ID: <20080912163534.GD1916@fluff.org.uk>
References: <863377.52660.qm@web57102.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863377.52660.qm@web57102.mail.re3.yahoo.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 06:35:43AM -0700, vidhumouli hunsigida wrote:
> The I2C host controller chip has two features named
> HOLD and Slave Monitor.
> 
> HOLD is the typical feature of holding the clock low to support for the slow devices.
> It can be enabled or disabled through software control by writing a bit in the registor.

This should be normal behaviour for an i2c bus, some controllers
can support it, but there is no need to add any extra functionality
to the i2c layer for this. The driver is free to do it or not do it.

If you want to driver to do either, then you can either have it as a
module parameter and/or have some configuration file in sysfs to change
the state.
 
> I am writing a bus driver for this core.
> I am not sure where and how this provision is to be added in the I2C adapter code.
> 
> I could not find any such provision in the exising bus drivers.
> I could not find any related information in the Linux kernel documentation.
> 
> Can any one give me how can this be done?
> 
> Similarly for Slave Monitor, where a host monitors for the ack received from the slave device.
> This can also be enabled/disabled by setting a bit in the register. How is this to be handled in the current i2c adapter code?

I suggest you have a look at the drivers in drivers/i2c/busses and
also include/linux/i2c.h (pay particual attention to 'struct i2c_algorithm'
which can be used to add new bus drivers).

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
