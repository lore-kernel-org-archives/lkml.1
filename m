Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0CBGt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:49:59 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:59338 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0CBGt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:49:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RlVTVNQbfH6GbFsyX+unBj6ic19w5Mo7EljZDxHVRy+ouq1hxOMseBqe5hmiTqJFjZ
         nWGKC3y4OvowNXLJyLaPpBD4voWdZe9rXFPwnDsuHFQ7v0YaFKESOGK3nnRIJyNz4kF0
         SzpoPS4lYVDuoJ1ANQGpZhci67kfeql73/BNg=
MIME-Version: 1.0
In-Reply-To: <0b055dc4810836e24ff21a776504142b.squirrel@intranet.cs.nmsu.edu>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
	 <45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
	 <0b055dc4810836e24ff21a776504142b.squirrel@intranet.cs.nmsu.edu>
Date: Tue, 2 Mar 2010 14:49:55 +0800
Message-ID: <45a44e481003012249p6970d442o593af7d4971f0183@mail.gmail.com>
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: linux-kernel@vger.kernel.org, npavel@ituner.com, tomi.valkeinen@nokia.com,
       tony@atomide.com, florianschandinat@gmx.de, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-fbdev@vger.kernel.org, jkosina@suse.cz,
       bonbons@linux-vserver.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 12:10 AM, Rick L. Vinyard, Jr.
<rvinyard@cs.nmsu.edu> wrote:
> Jaya Kumar wrote:
>> Hi Rick,
>>
>> On Fri, Feb 26, 2010 at 6:15 AM, Rick L. Vinyard Jr.
>> <rvinyard@cs.nmsu.edu> wrote:
>>
>>> +               Set the deferred I/O delay of the framebuffer in ms.
>>> +               This value can be used to throttle deferred I/O updates.
>>
>> Please help us understand how userspace should use the ability to set
>> this delay.
>
> I think that there isn't one specific answer since, just like the approach
> to priority of processes there isn't one specific answer. The real answer
> is: it depends.

Rick,

Thanks for your reply.

>
> One of the factors I was concerned about was having two or more G13
> devices on the same bus with other traffic. Each frame is sent as an
> interrupt transfer out, and I was concerned that the framebuffer updates
> might be detrimental to other traffic.
>
> I know that a pair of G13 devices running at 30 FPS would only consume
> about 5% of the USB 1.1 bandwidth (~500 Mbit/s) for framebuffer transfers
> (sans headers and other control messages), but I was concerned that it
> could introduce enough latency to make other devices laggy.

You mentioned in your responses and above that you're concerned about
saturating the USB bus and lagginess, and I think it is good to have
those concerns. Defio delay may be an easy parameter to expose, and in
at least a specific set of drivers, changing it would have a
meaningful effect on bus utilization, but are you convinced that
exposing it generally (remember your patch makes it apply to all fb
drivers) to userspace is a right way or even a good way to address bus
saturation concerns?

> As a result of this translation, I was concerned with the driver consuming
> too much CPU time when doing multiple translations for multiple devices...
> or even one translation on a limited or saturated CPU at a high frame
> rate.

Being concerned about CPU utilization is a good thing. But say for
example, your USB ethernet driver or USB audio driver is taking a lot
of cpu time packetizing traffic, then would I be correct that your
desire is to expose an inter-packetization driver specific sleep time
controllable by userspace via sysfs for all ethernet, audio, etc
drivers? (by driver specific, I mean the sysfs parameter would be
presented by all drivers but the value would be specific to each one,
which is the way your current patch would behave for all fb drivers).

> I think it would be an interesting possibility to develop a daemon that
> watched traffic on buses with USB devices that could be throttled and
> throttle them according to bus saturation.
>
> However, at this point I wasn't planning on going there. But, having the
> ability to throttle would be a key point for developing such daemons.

Just curious, do such sysfs throttling parameters exist for any other
subsystems? If so, are userspace apps/services using them, and are
they happy with it?

Thanks,
jaya
