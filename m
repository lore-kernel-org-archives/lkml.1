Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbYEOVAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbYEOVAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbYEOU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:59:55 -0400
Received: from eazy.amigager.de ([213.239.192.238]:34668 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbYEOU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:59:54 -0400
Date: Thu, 15 May 2008 22:59:50 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, jkosina@suse.cz, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080515205950.GA11794@dose.home.local>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg KH <greg@kroah.com>, jkosina@suse.cz,
	linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080514221519.GA6575@kroah.com> <20080515132108.GA9327@dose.home.local> <20080515094212.ZZRA012@mailhub.coreip.homeip.net> <20080515174939.GA10881@dose.home.local> <20080515142845.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515142845.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 14:35:54 -0400, Dmitry Torokhov wrote:
> On Thu, May 15, 2008 at 07:49:39PM +0200, Tino Keitel wrote:

[...]

> > I know. I just wanted to point out that this is a regression for all
> > people who use the macmini LIRC driver. This driver was present at
> > least in the last 2 LIRC releases. The quirks stuff in the above patch
> > looks like there is no way to make the macmini LIRC driver work with
> > the patch applied. It relies on a USB HID device, which wouldn't be
> > created anymore, and the user has no way to bring it back. Please
> > correct me with a pointer to the appropriate documentation if I'm
> > wrong.
> >
> 
> There is a way to dynamically manipulate quirks for a VID/PID pair
> via sysfs. I think if you set the quirk to 0 it will efefctively
> disable the ignore quirk restoring the old behaviour.

Where in sysfs? I found module/usbhid/parameters/quirks and quirks
files in several devices/pci0000:00/* directories. I guess you are
talking about the latter.

How can I tell what device I need to use, or what is the recommended
way? I can only think of something ugly like

$ find /sys -name "idProduct" | xargs grep 8240

and similar with idVendor.

Does setting the quirks to 0 lead to the creation of a HID device
immediately? Where is this documented? Could it be implemented in a way
such that the user has a HID device, as long as he doesn't enable the
appleir driver?

> 
> > From the user's point of view: There are no official kernel release
> > notes about what devices are added/removed to/from the various
> > ignore lists and blacklists. The kernel doesn't produce any output
> > about devices that are ignored or blacklisted in may cases (and
> > also this one). The user has no indication why his LIRC setup stops
> > working with the new kernel.
> >
> 
> Not sure what we can do here... The only thing I guess is better
> commit message mentioning LIRC setup concerns.

Who reads commit messages? I think it should be easy to add some
printk()s saying something like "skipping device foo, because it is on
the ignore list".

> > Even if all LIRC users switch to the appleir driver, what about
> > people who use a learning remote to have more than 6 keys that the
> > Apple remote has? Does this work at all? After a quick look at the
> > key handling it seems to me that the codes of the 6 keys are
> > hardcoded in the driver. So a learning remote with more keys
> > wouldn't work anymore.
> >
> 
> We'll have to adjust the driver to allow changing keymap on a
> per-device base from userspace. That's pretty easy actually.

I'm not talking about the keymap that is visible in userspace, but
about the keys on the remote that are detected by the kernel. The Apple
remote has only 6 keys, and they are mapped in a static array:

#define MAX_KEYS       8
static int keymap[MAX_KEYS] = ...

With the LIRC driver, I can use a learning remote with much more keys,
and then just use irrecord to create a LIRC config file.

Regards,
Tino
