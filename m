Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYANK6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYANK6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYANK56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:57:58 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34369 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754019AbYANK55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:57:57 -0500
Date: Mon, 14 Jan 2008 11:57:52 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jon Smirl <jonsmirl@gmail.com>
cc: Jean Delvare <khali@linux-fr.org>, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH] update module-init-tools to support the i2c
 subsystem
In-Reply-To: <9e4733910801131004i669276e2pde04b195dd10bd90@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801141154420.3058@vixen.sonytel.be>
References: <9e4733910712171839h214e0bc3q179266c86e5987b1@mail.gmail.com>
 <20080113152735.5dca46a1@hyperion.delvare> <9e4733910801130714m1be16826jf240171972324d16@mail.gmail.com>
 <20080113163543.16e3d26b@hyperion.delvare> <9e4733910801130826l799e4897pe7380ccb973b5fd0@mail.gmail.com>
 <20080113184337.5d4cd546@hyperion.delvare> <9e4733910801131004i669276e2pde04b195dd10bd90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1465604188-1200308272=:3058"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1465604188-1200308272=:3058
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 13 Jan 2008, Jon Smirl wrote:
> On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > On Sun, 13 Jan 2008 11:26:07 -0500, Jon Smirl wrote:
> > > On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > > > On Sun, 13 Jan 2008 10:14:14 -0500, Jon Smirl wrote:
> > > > > On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > > > > > On Mon, 17 Dec 2007 21:39:37 -0500, Jon Smirl wrote:
> > > > > > > Follow on to: "Series to add device tree naming to i2c"
> > > > > > > Teach module-init-tools about the i2c subsystem.
> > > > > >
> > > > > > Can you please explain what this patch does and why it is needed?
> > > > >
> > > > > It generates the entries needed for the user space module tools to
> > > > > work with the aliases. For example modprobe/depmod. It is a standard
> > > > > part of the kernel module system.
> > > >
> > > > What entries, where? What can you do after applying your patch that you
> > > > couldn't do before?
> > >
> > > The drivers you are testing with don't depend on other drivers.
> >
> > They do. I'm testing with the lm90 driver, which depends on the hwmon
> > driver. Both load automatically when the underlying i2c-parport driver
> > instantiate an "adm1032" i2c device.
> 
> I don't know exactly what those modules tables are used for. I just
> copied what the other subsystems do. Maybe they are used when you make
> an initrd to know which drivers to copy into the image.

Module-init-tools needs those table to create module aliases in the *.ko
files from the MODULE_DEVICE_TABLE(), so udev can load the modules based
on the device IDs when the devices appear in sysfs.

That's the generic part. How this applies to i2c devices on platforms
without Open Firmware device trees is another question. I guess that's
where Jean gets confused (i2c_device_id got _removed_ last year,
because it didn't make sense (at the time?)).

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-1465604188-1200308272=:3058--
