Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZGUQBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZGUQBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZGUQBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:01:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:14159 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbZGUQBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,240,1246863600"; 
   d="scan'208";a="167349987"
From: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>
To: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
Date: Tue, 21 Jul 2009 21:30:57 +0530
Subject: RE: x86: IPC driver patch for Intel Moorestown platform
Thread-Topic: x86: IPC driver patch for Intel Moorestown platform
Thread-Index: AcoKF0A/Qu2p2q8CRjyi+kJ0JpWaygAA6bpA
Message-ID: <98769532B4BB14429434178695419EAE5F45B41A@bgsmsx501.gar.corp.intel.com>
References: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com>
 <200907211700.21059.arnd@arndb.de>
 <20090721161023.7607ea7f@lxorguk.ukuu.org.uk>
 <200907211723.36862.arnd@arndb.de>
In-Reply-To: <200907211723.36862.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 21 July 2009, Alan Cox wrote:
> > 1. built-in code adds platform-device for mrst_ipc
> > 2. user space auto-loads the mrst_ipc driver
The IPC driver APIs for host drivers communicate with the SCU (System Controller Unit) firmware on the platform. It is used by many Moorestown platform specific drivers such as Audio, Touch Screen, GPIO, Battery, Power Management etc for accessing PMIC (Power Management Interrupt Controller). It will typically get loaded during boot and gets unloaded on shutdown. I don't think it should be loaded and unloaded by the user-space apps.

> > 3. mrst_ipc driver creates child devices for each of its attached
> >    devices
>
> The devices talking to it already are devices - but they will be input
> devices, watchdogs, etc. They already belong in existing classes.

> Remember that devices normally are both in the /sys/class hierarchy
> as a class device and in the /sys/devices hierarchy based on their
> attachment.

The IPC driver not device specific but it is Moorestown platform specific. Although different APIs are listed, the primary functionality of the driver is communicating with the SCU firmware via which hardware is accessed.

> I also don't believe the mrst ipc is enumerable either. If it was
> enumerable it would make a lot more sense.

Yes, it is not enumerable.

> It could be done along the same lines as ./drivers/input/serio/i8042.c:

> The platform knows when an i8042 chip is present and adds the
> serio devices it statically knows about. The serio driver then
> adds input class devices for them. You probably wouldn't /have/
> to add a new bus_type but could reuse nested platform devices.

        Arnd <><
