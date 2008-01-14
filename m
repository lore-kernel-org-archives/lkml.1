Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbYANO0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbYANO0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYANOZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:25:59 -0500
Received: from ro-out-1112.google.com ([72.14.202.176]:47755 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYANOZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:25:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CNtG+eiEFMT8QK2iYx42WYX8MwJYhYBVZTfqhuxup2D4n6DZjB6l/OPiMU7LbHf8vy/HPHAQ1zy4TxOxI/+Nk+ho0Fm0Y2Gb9rLzNgXp7LD4jfN+4N6Y+jWrWr6+HhNtSaYAUgdMm7lefdqH1EEzrKFaBPXvpT24OmPf4uH6eSA=
Message-ID: <9e4733910801140625u2503b508kc99e93ff59e31157@mail.gmail.com>
Date: Mon, 14 Jan 2008 09:25:54 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [i2c] [PATCH] update module-init-tools to support the i2c subsystem
Cc: "Jean Delvare" <khali@linux-fr.org>, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801141154420.3058@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <9e4733910712171839h214e0bc3q179266c86e5987b1@mail.gmail.com>
	 <20080113152735.5dca46a1@hyperion.delvare>
	 <9e4733910801130714m1be16826jf240171972324d16@mail.gmail.com>
	 <20080113163543.16e3d26b@hyperion.delvare>
	 <9e4733910801130826l799e4897pe7380ccb973b5fd0@mail.gmail.com>
	 <20080113184337.5d4cd546@hyperion.delvare>
	 <9e4733910801131004i669276e2pde04b195dd10bd90@mail.gmail.com>
	 <Pine.LNX.4.64.0801141154420.3058@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/08, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> On Sun, 13 Jan 2008, Jon Smirl wrote:
> > On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > > On Sun, 13 Jan 2008 11:26:07 -0500, Jon Smirl wrote:
> > > > On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > > > > On Sun, 13 Jan 2008 10:14:14 -0500, Jon Smirl wrote:
> > > > > > On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > > > > > > On Mon, 17 Dec 2007 21:39:37 -0500, Jon Smirl wrote:
> > > > > > > > Follow on to: "Series to add device tree naming to i2c"
> > > > > > > > Teach module-init-tools about the i2c subsystem.
> > > > > > >
> > > > > > > Can you please explain what this patch does and why it is needed?
> > > > > >
> > > > > > It generates the entries needed for the user space module tools to
> > > > > > work with the aliases. For example modprobe/depmod. It is a standard
> > > > > > part of the kernel module system.
> > > > >
> > > > > What entries, where? What can you do after applying your patch that you
> > > > > couldn't do before?
> > > >
> > > > The drivers you are testing with don't depend on other drivers.
> > >
> > > They do. I'm testing with the lm90 driver, which depends on the hwmon
> > > driver. Both load automatically when the underlying i2c-parport driver
> > > instantiate an "adm1032" i2c device.
> >
> > I don't know exactly what those modules tables are used for. I just
> > copied what the other subsystems do. Maybe they are used when you make
> > an initrd to know which drivers to copy into the image.
>
> Module-init-tools needs those table to create module aliases in the *.ko
> files from the MODULE_DEVICE_TABLE(), so udev can load the modules based
> on the device IDs when the devices appear in sysfs.
>
> That's the generic part. How this applies to i2c devices on platforms
> without Open Firmware device trees is another question. I guess that's
> where Jean gets confused (i2c_device_id got _removed_ last year,
> because it didn't make sense (at the time?)).

Last year i2c modules weren't dynamically loadable so it wasn't needed.

>
> With kind regards,
>
> Geert Uytterhoeven
> Software Architect
>
> Sony Network and Software Technology Center Europe
> The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
>
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@sonycom.com
> Internet: http://www.sony-europe.com/
>
> Sony Network and Software Technology Center Europe
> A division of Sony Service Centre (Europe) N.V.
> Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
> VAT BE 0413.825.160 · RPR Brussels
> Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619


-- 
Jon Smirl
jonsmirl@gmail.com
