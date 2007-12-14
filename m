Return-Path: <linux-kernel-owner+w=401wt.eu-S934027AbXLNQvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027AbXLNQvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbXLNQvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:51:44 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:51343 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbXLNQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:51:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 17:49:33 +0100
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <200712141409.00311.mb@bu3sch.de> <2c0942db0712140806p61ec06d5nf3289dab938fd93a@mail.gmail.com>
In-Reply-To: <2c0942db0712140806p61ec06d5nf3289dab938fd93a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141749.33708.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 17:06:39 Ray Lee wrote:
> Hi all. Perhaps I can inject some facts into this?
> 
> On Dec 14, 2007 5:08 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > > > This user did get the following messages in dmesg:
> > > >
> > > > b43err(dev->wl, "Firmware file \"%s\" not found "
> > > >        "or load failed.\n", path);
> > > > b43err(wl, "You must go to "
> > > >        "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
> > > >        "and download the correct firmware (version 4).\n");
> > > >
> > > > I'm not sure how I can improve that even more. There is a full URL
> > > > describing how to get the device workin in _full_ detail.
> 
> Yes, but only if you load rfkill-input and rfkill by hand, prior.

I'm not sure what you are doing there.
Do you have module autoloading disabled?
This all works perfectly well on all of my systems. And I never heared
such a problem before.

If you have a PCI device probing works as follows:
The PCI table is in ssb. So as soon as your kernel detects the PCI device
it will load ssb. ssb will register the PCI device. That will trigger
an udev event for the contained 802.11 core to get probed. This will load
b43.

So, I'm not sure where's the issue with my code here.

> That I'm one of the first people to hit that makes me think that your
> testing base so far has been miniscule.

The driver is shipped by Fedora since quite some time.

> > > || Well, doing an `rmmod bcm43xx ; modprobe ssb b43` gives me nothing in
> > > || dmesg other than lines related to the bcm43xx driver.
> > > || iwconfig/ifconfig do not see the interface either.
> 
> See above. Without a modprobe of rfkill, rfkill-input that is the case.

You can't do
modprobe ssb b43
This will be interpreted as modprobe of "ssb" with the module
parameter "b43". At least by my modutils.

If you do
modprobe b43
it will automatically load _all_ required modules.
It works perfectly well on my systems.
Try it. Simply type "modprobe b43". It will also work for you.

> Heeeeellooooo? I tried that. It failed. What *I'm* talking about here
> is that this everyone needs to be aware that this is *not* a drop in
> replacement for bcm43xx, and if I'm having problems (not a kernel
> hacker, but I make my living writing code), then sheesh, you're gonna
> have a flood of people needing hand-holding on this.

All problems so far were not related to the b43 sourcecode at all.
And I think I can not be held responsible for unrelated code or bugs
in the operating system scripts.

-- 
Greetings Michael.
