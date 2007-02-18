Return-Path: <linux-kernel-owner+w=401wt.eu-S965491AbXBRAuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965491AbXBRAuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965486AbXBRAuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:50:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:52882 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965491AbXBRAuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:50:00 -0500
Subject: Re: [PATCH 2.6.21-rc1] powerpc: Make of_device_uevent()
	compatible	with ibmebus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>, johnrose@us.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       pmac@au1.ibm.com, Sylvain Munaut <tnt@246tnt.com>
In-Reply-To: <OF8D0E4DD6.8DF18C46-ON85257286.00002C8B-85257286.0001FC97@de.ibm.com>
References: <OF8D0E4DD6.8DF18C46-ON85257286.00002C8B-85257286.0001FC97@de.ibm.com>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 11:37:25 +1100
Message-Id: <1171759045.5644.148.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 19:21 -0500, Joachim Fenkes wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote on 17.02.2007 
> 16:56:39:
> 
> > On Sat, 2007-02-17 at 17:28 +0100, Hoang-Nam Nguyen wrote:
> > > ibmebus has a fake root device that's not associated with an ofdt 
> node.
> > > Filter out any such devices in of_device_uevent().
> > 
> > Doh ! You are creating an of_device with no attached device-node ? That
> > is totally evil ! Why do you need that ?
> 
> The driver creates a fake "ibmebus" device so all ibmebus based devices 
> have
> a common parent device -- the vio bus does the same.
> 
> What do you think about linking this device to the device tree "/" node? 
> All
> ibmebus-based devices are linked to dt nodes residing directly beneath 
> "/",
> so the mapping would fit.

No. If you do that, it shouldn't be an of_device based device.

If you want then to be below a common parent, then create that parent of
a basic struct device type, that sort of thing. You should never
instanciate an of_device that has a NULL device node.

vio is different since it's not a "subclass" of of_device though I tend
to also disagree with the way it does things.

It's a generic problem with sysfs, I agree it somewhat sucks.

Ben.


