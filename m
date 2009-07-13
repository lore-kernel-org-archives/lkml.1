Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZGMJjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZGMJjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbZGMJjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:39:22 -0400
Received: from ppp-145-35.adsl.restena.lu ([158.64.145.35]:49427 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbZGMJjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:39:21 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 05:39:21 EDT
Date: Mon, 13 Jul 2009 11:31:57 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mark Lord <lkml@rtr.ca>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: Input driver for Twinhan USB 6253:0100 remote control
Message-ID: <20090713113157.701ba027@neptune.home>
In-Reply-To: <alpine.LNX.2.00.0907131048110.10476@wotan.suse.de>
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com>
	<200904131931.24009.dmitry.torokhov@gmail.com>
	<49E4B678.9030508@rtr.ca>
	<200904140945.14652.dmitry.torokhov@gmail.com>
	<49E4C9CF.5060504@rtr.ca>
	<alpine.LNX.2.00.0904151022170.13028@wotan.suse.de>
	<49E5EAD7.7000309@rtr.ca>
	<alpine.LNX.2.00.0904161123180.13028@wotan.suse.de>
	<20090712182026.7a09c736@neptune.home>
	<alpine.LNX.2.00.0907131048110.10476@wotan.suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 July 2009 Jiri Kosina <jkosina@suse.cz> wrote:
> On Sun, 12 Jul 2009, Bruno Prémont wrote:
> 
> > I wrote the below patch to adjust it's key mappings, though I'm not
> > sure if/how I should deal with the number keys (0..9) with regard to
> > keyboard layout and/or numlock key.
> > 
> > I tried with KEY_0..KEY_9 (default) as well as KEY_KP0..KEY_KP9 but
> > neither produces optimal results on my machine (laptop with numlock
> > disabled and belgian keyboard layout, e.g. KEY_1 => '&' unless shift
> > is down)
> > 
> > KEY_NUMERIC_0..KEY_NUMERIC_9 are not recognized by Linux console
> > (don't know if/how userspace understands them)
> 
> Are they incorporated in the keymap you have loaded?

Probably not though I have not checked (using be-latin1 from
sys-apps/kbd-1.13-r1, Gentoo) Possibly this kbd version is too old to
know about those keys.

> > +	// set_bit(EV_REP, hi->input->evbit);
> 
> Why is this commented out?

That was a remaining line from basing on hid-gyration.c
Don't know what it does, looks like related to key repeating but I've
not read enough of HID/Input code to find out. (all my tests were run
with it commented out, so I will drop it unless there is a good reason
to uncomment it)

> Otherwise the patch looks good, so if you send it with proper 
> Signed-off-by line, I am OK with merging it.

Will do, using KEY_NUMERIC_*.

> Do you have any idea whether lirc folks have plans to integrate
> support for this device to lirc eventually?

I don't know


With my patch it seems the mappings don't show up for EVIOCGKEYCODE:

int codes[2];
for (codes[0] = 0; codes[0] < 1024; codes[0]++)
  if (ioctl(evdev, EVIOCGKEYCODE, codes) >= 0) {
    // display
  } else
    break;

Code block above only displays for codes[0] == 0:
 codes = { 0, 388 /* KEY_TEXT */ }

For all other values of codes[0] ioctl returns EINVAL.

Is this expected or should complete mapping table be returned
as it is for generic PS2 PC keyboard (if so, what changes does the
patch need for it)?

Bruno
