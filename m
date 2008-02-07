Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbYBGTOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbYBGTOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932995AbYBGTN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:13:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761658AbYBGTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:13:26 -0500
Date: Thu, 7 Feb 2008 11:12:20 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] apanel: fix kconfig dependencies
Message-ID: <20080207111220.4239d5d4@extreme>
In-Reply-To: <20080207110412.792db623.randy.dunlap@oracle.com>
References: <20080206162754.73114579.randy.dunlap@oracle.com>
	<20080207174251.1b895234@hyperion.delvare>
	<20080207110412.792db623.randy.dunlap@oracle.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 11:04:12 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 7 Feb 2008 17:42:51 +0100 Jean Delvare wrote:
> 
> > Hi Randy,
> > 
> > On Wed, 6 Feb 2008 16:27:54 -0800, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Add I2C to config since the driver makes several i2c*() calls.
> > 
> > Correct.
> > 
> > > 
> > > Add PCI to config because the config selects I2C_I801, which depends
> > > on PCI, but currently config* does not follow dependency chains,
> > > so randconfig can enable INPUT_APANEL even when PCI is not enabled,
> > > which leads to these warnings:
> > > linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:641: error: implicit declaration of function 'pci_request_region'
> > > /linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:681: error: implicit declaration of function 'pci_release_region'
> > 
> > I'd rather drop the "select I2C_I801" if the config system can't handle
> > it properly. It's not strictly needed (not a build-time dependency), an
> > addition to the help text would work as well. Adding dependencies to
> > make our selections happy is a bit confusing and likely to cause
> > trouble in the future (as dependencies can change...)
> 
> OK.  What did you have in mind for the help text.  I changed it
> a small bit.
> 
> I also added "depends on LEDS_CLASS" since defconfig didn't have that
> set, but the build failed with wanting symbols that it provides.
> 
> Updated patch:
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add I2C to config since the driver makes several i2c*() calls.
> 
> Add to help text that the Intel I2C ICH (i801) driver is also needed
> for this kernel.
> 
> Add LEDS_CLASS to config since the driver makes les_classdev_*() calls:
> ERROR: "led_classdev_register" [drivers/input/misc/apanel.ko] undefined!
> ERROR: "__led_classdev_unregister" [drivers/input/misc/apanel.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>


On a related note, Ubuntu puts the i2c_i801 module in /etc/modprobe.d/blacklist.
To get the apanel to work, this must be removed, but that is a distro bug.

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
