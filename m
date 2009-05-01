Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZEAKUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZEAKUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZEAKTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:19:52 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:63802 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZEAKTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vuAAOzVZRLiP4tQHxibD8Jt76W1tknG+2UBvX4Uw2JCKZ1XO+4Ozyr1JR+K2V08N6+
         XReNM8a2Bktc8fF7+7HMMr5m4hbO2VaukpqZ6qchfaK/Mv5TlrMmBCE2TmcH4AWCWWMl
         jML84aaVga0T/t5VSq5qFqng6N43PlmmEQ3c0=
MIME-Version: 1.0
In-Reply-To: <1241097822.2516.3.camel@poy>
References: <1241097822.2516.3.camel@poy>
Date: Fri, 1 May 2009 11:19:49 +0100
Message-ID: <9b2b86520905010319g4b1e915ejc5c17baa519f3d35@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/09, Kay Sievers <kay.sievers@vrfy.org> wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: driver-core: devtmpfs - driver core maintained /dev tmpfs
>
> Devtmpfs lets the kernel create a tmpfs very early at kernel
> initialization, before any driver core device is registered. Every
> device with a major/minor will have a device node created in this
> tmpfs instance. After the rootfs is mounted by the kernel, the
> populated tmpfs is mounted at /dev. In initramfs, it can be moved
> to the manually mounted root filesystem before /sbin/init is
> executed.
>
> The tmpfs instance can be changed and altered by userspace at any time,
> and in any way needed - just like today's udev-mounted tmpfs. Unmodified
> udev versions will run just fine on top of it, and will recognize an
> already existing kernel-created device node and use it.
> The default node permissions are root:root 0600. Only if none of these
> values have been changed by userspace, the driver core will remove the
> device node when the device goes away. If the device node was altered
> by udev, by applying the appropriate permissions and ownership, it will
> need to be removed by udev - just as it usually works today.
>
> This makes init=/bin/sh work without any further userspace support.
> /dev will be fully populated and dynamic, and always reflect the current
> device state of the kernel. Especially in the face of the already
> implemented dynamic device numbers for block devices, this can be very
> helpful in a rescue situation, where static devices nodes no longer
> work.
> Custom, embedded-like systems should be able to use this as a dynamic
> /dev directory without any need for aditional userspace tools.
>
> With the kernel populated /dev, existing initramfs or kernel-mount
> bootup logic can be optimized to be more efficient, and not to require a
> full coldplug run, which is currently needed to bootstrap the inital
> /dev directory content, before continuing bringing up the rest of
> the system. There will be no missed events to replay, because /dev is
> available before the first kernel device is registered with the core.
> A coldplug run can take, depending on the speed of the system and the
> amount of devices which need to be handled, from one to several seconds.

Aren't you overeaching in your claims here?  I'm sure you can't avoid
at least one coldplug run on a contemporary general purpose system,
because you lose so much of the functionality provided by udev.  I'm
sure of that, but it would be nice if you could address it in the
changelog.  And modern initramfs' require udev RUN rules to read UUIDs
and set up LVM.

I'm loving this for embedded, init=/bin/sh, and rescue floppies :-).
But I can't understand how you plan to use this as an optimisation.

And - I'm sure you must have considered this in a moment of madness -
do you know why we couldn't just start _udev_ "before the first kernel
device is registered with the core"?

Regards
Alan
