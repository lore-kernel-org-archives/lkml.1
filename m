Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049Ab0BZCag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 21:30:36 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:58973 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935018Ab0BZCae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 21:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QxbKqflBruzeNNGjvbiJgzMHOJDxX+MSJ364xiMS8kuDEPW3K/6/yu8UEEn8Csjib3
         cbyX2CzQ4DEAUQ2San6uOabiLRM7YfaRVRFaF3MuQuUeFDp7s05fzN2ZM0oGDcJREy7u
         WiRmZUABln5vxr97cZduve6GcGmCx+5b2QjjU=
MIME-Version: 1.0
In-Reply-To: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
Date: Fri, 26 Feb 2010 10:30:32 +0800
Message-ID: <45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Cc: linux-kernel@vger.kernel.org, npavel@ituner.com, tomi.valkeinen@nokia.com,
       tony@atomide.com, FlorianSchandinat@gmx.de, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-fbdev@vger.kernel.org, jkosina@suse.cz,
       bonbons@linux-vserver.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rick,

On Fri, Feb 26, 2010 at 6:15 AM, Rick L. Vinyard Jr.
<rvinyard@cs.nmsu.edu> wrote:
> This patch adds support for examining and modifying the fbdefio delay
> parameter through sysfs. It also adds two driver definable minimum
> and maximum bounds.

Thanks for posting this. I've now read through this patch and your
past patches, but I couldn't get a good understanding of how this
userspace exposed defio delay would interact with most existing
systems.

> +               Set the deferred I/O delay of the framebuffer in ms.
> +               This value can be used to throttle deferred I/O updates.

Please help us understand how userspace should use the ability to set
this delay. Who in userspace is intended to use it? Would this be the
X server, cairo, or papyrus? A separate daemon? Human interaction?
When should said userspace entity throttle updates? How would this
entity know when throttling is needed? Could this throttling possibly
or should this possibly be done automatically by the driver itself?

> +               Most framebuffer devices do not have or need support for
> +               deferred I/O. Accessing a framebuffer without deferred I/O
> +               support will return -ENODEV. Can be read but not modified if
> +               /sys/class/graphics/<fb>/defio_delay_max is 0. When modifying,
> +               the value must be greater than or equal to
> +               /sys/class/graphics/<fb>/defio_delay_min and less than or equal
> +               to /sys/class/graphics/<fb>/defio_delay_max.

Please help the reader of above understand the sequence of userspace
changing the defio delay, and how and when that would affect the
associated drivers. Will the delay behaviour be standard for all defio
client drivers? What happens in all the various timing scenarios, eg:
if a defio delay is changed in the middle of a display update or a
defio page clean or before? The sysfs parameter description mentioning
min/max above could use some elaboration as reading it doesn't make
clear if userspace can also affect min/max or if it is completely
owned by the driver.

Thanks,
jaya

ps: I only found your patches by accident when reading through the
fbdev mailing list. I'm very interested in defio (I happen to be the
author of it) and also drivers that use defio so I would appreciate
being CCed on such changes. Thanks a bunch.
