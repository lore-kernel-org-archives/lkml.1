Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbYEORty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbYEORty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYEORtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:49:43 -0400
Received: from eazy.amigager.de ([213.239.192.238]:50591 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYEORtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:49:41 -0400
Date: Thu, 15 May 2008 19:49:39 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, jkosina@suse.cz, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080515174939.GA10881@dose.home.local>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg KH <greg@kroah.com>, jkosina@suse.cz,
	linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080514221519.GA6575@kroah.com> <20080515132108.GA9327@dose.home.local> <20080515094212.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515094212.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 09:45:52 -0400, Dmitry Torokhov wrote:
> Hi Tino,
> 
> On Thu, May 15, 2008 at 03:21:08PM +0200, Tino Keitel wrote:
> > Hi,
> >
> > I'm pretty sure that this breaks the macmini LIRC driver again, see
> > commit 3e1928e8793208802589aae851b6685671187242.
> >
> 
> But with in-kernel driver can't LIRC feed of event device?

Sure, it can. But in its current state, it breaks existing scenarios
and seems to have restrictions. See the comment below regarding
learning remotes, and my other mail in this thread regarding broken
suspend with the appleir driver.

> Ane people that dont use LIRC can also have access to the remote?

I know. I just wanted to point out that this is a regression for all
people who use the macmini LIRC driver. This driver was present at
least in the last 2 LIRC releases. The quirks stuff in the above patch
looks like there is no way to make the macmini LIRC driver work with
the patch applied. It relies on a USB HID device, which wouldn't be
created anymore, and the user has no way to bring it back. Please
correct me with a pointer to the appropriate documentation if I'm
wrong.

>From the user's point of view: There are no official kernel release
notes about what devices are added/removed to/from the various ignore
lists and blacklists. The kernel doesn't produce any output about
devices that are ignored or blacklisted in may cases (and also this
one). The user has no indication why his LIRC setup stops working with
the new kernel.

Even if all LIRC users switch to the appleir driver, what about people
who use a learning remote to have more than 6 keys that the Apple
remote has? Does this work at all? After a quick look at the key
handling it seems to me that the codes of the 6 keys are hardcoded in
the driver. So a learning remote with more keys wouldn't work anymore.

Regards,
Tino
