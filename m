Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZEALNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZEALNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZEALNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:13:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:52205 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZEALNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:13:37 -0400
MIME-Version: 1.0
In-Reply-To: <9b2b86520905010319g4b1e915ejc5c17baa519f3d35@mail.gmail.com>
References: <1241097822.2516.3.camel@poy> <9b2b86520905010319g4b1e915ejc5c17baa519f3d35@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 13:13:16 +0200
Message-ID: <ac3eb2510905010413y6b35e817nf948cedbe076cd4d@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 12:19, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> On 4/30/09, Kay Sievers <kay.sievers@vrfy.org> wrote:

>> With the kernel populated /dev, existing initramfs or kernel-mount
>> bootup logic can be optimized to be more efficient, and not to require a
>> full coldplug run, which is currently needed to bootstrap the inital
>> /dev directory content, before continuing bringing up the rest of
>> the system. There will be no missed events to replay, because /dev is
>> available before the first kernel device is registered with the core.
>> A coldplug run can take, depending on the speed of the system and the
>> amount of devices which need to be handled, from one to several seconds.
>
> Aren't you overeaching in your claims here?  I'm sure you can't avoid
> at least one coldplug run on a contemporary general purpose system,

You still need coldplug, sure. But distros have 2 full coldplugs
today, one in initramfs, one in the rootfs.

> because you lose so much of the functionality provided by udev.

No, udev will do the same thing as it does today, it will not be
different, it's just that the colplug can run in parallel with other
stuff, and the initramfs coldplug can be much simplified, or even
avoided.

> I'm
> sure of that, but it would be nice if you could address it in the
> changelog.  And modern initramfs' require udev RUN rules to read UUIDs
> and set up LVM.

A simple uuid/label lookup will not need a full coldplug run in
initramfs. You just need to start udev, and wait for the links to show
up. Possibly running triggering block events, but not the hundreds of
other devices.

> I'm loving this for embedded, init=/bin/sh, and rescue floppies :-).
> But I can't understand how you plan to use this as an optimisation.
>
> And - I'm sure you must have considered this in a moment of madness -
> do you know why we couldn't just start _udev_ "before the first kernel
> device is registered with the core"?

I think it's pretty obvious, that this is the fastest you can get for
/dev. And it's not about the time when udev is started, its about
doing the stuff when the devices are created, and not to need to redo
it at bootup, or do it even twice.

Thanks,
Kay
