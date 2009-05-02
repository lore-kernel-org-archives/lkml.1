Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZEBPfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZEBPfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 11:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZEBPff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 11:35:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:60868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZEBPff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 11:35:35 -0400
MIME-Version: 1.0
In-Reply-To: <49FC6439.80704@myrealbox.com>
References: <1241097822.2516.3.camel@poy> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 
	<20090501065527.GA19773@kroah.com> <20090501120359.05bacb48@lxorguk.ukuu.org.uk> 
	<ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> 
	<20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> 
	<20090502071939.GA14094@infradead.org> <ac3eb2510905020646k28ebaf07j2216c6f3f614748c@mail.gmail.com> 
	<49FC6439.80704@myrealbox.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 2 May 2009 17:35:19 +0200
Message-ID: <ac3eb2510905020835o66f46b03ra2ec24b5594ff7c6@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Andy Lutomirski <luto@myrealbox.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 17:18, Andy Lutomirski <luto@myrealbox.com> wrote:
> What's wrong with:
>
> mount -n -t sysfs none /sys
> mount -n -t tmpfs none /tmp

You need tmpfs on /dev, and you need initial nodes in the new tmpfs
before you can start udevd.

> udevd --daemon
> udevadm trigger

Then you need to wait for udev to finish, to be sure the nodes are
there, before you start anything else.

> once the shell comes up?

If the kernel mounts your root, and not initramfs, the shell does not
come up, when /dev is empty, like it is on some distros which always
use tmpfs on /dev.

> There could even be a standard script that all
> distributions ship that does that, plus mounts /proc and does whatever magic
> is needed to make Ctrl-C work.

There is no such thing today, as "standard that distros ship", and I
doubt there will be. We needed years to sync the device names across
distros. That happened now, but there will never be any "standard
thing that bring us a box that the kernel can "ship". Same for the
"let every new driver provide a udev rule for the names of the device
at the same time", that will never happen, people just don't care
about userspace issues at all - I've given up on trying that.

> (OK, so you depend on udev and mount working, but you already depend
> on sh working, and you'll have a heck of time rescuing anything if even
> mount doesn't work.)

You need access to your devices, and device numbers may be dynamic.
It's not about mount(8) is not working, you may have lost anyway in
such cases.

> If you want a really reliable rescue mode, then either put a whole working
> busybox system in a spare initramfs with a spare boot menu entry or just use
> a real rescue disk, neither of which require devtmpfs.

Yeah, why not have a spare box close to every one, then you can use
that instead. :) This is not about being prepared that stuff went
wrong, then you are lucky. You usually can not copy a new image to a
box that does not boot, and you do not have a working rescue disk
right next to you.

> As a separate question, what happens with devtmpfs if I plug in some device
> that uses dynamic minors, then unplug it, then plug in another device that
> gets a new minor but the same name, all before (or even after) udev starts?
>  Are there any subsystems that could do that?

The node gets removed, then a new one gets created for the new device.
Besides that there are no device with the same name at the same time
today, udev would not solve that problem either.

Thanks,
Kay
