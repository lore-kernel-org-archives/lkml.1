Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0CCAL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:11:27 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:59708 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0CCALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mzVUFUv4oQ5M5BDNKZRrBhm1ZZ/NmeTpP1g8CaDUeuxjnqt1voCbJonzeAbRHJxUx0
         eE2y9Hzeowq94AKo0Hwdo6rQFkBfbwNS1HGSLP8yrXTUMhrwdT9Q16dcJFYvXjjwzByo
         sQoralATqZR4eBVySJkLsw9PomiPyRoE9dMuo=
MIME-Version: 1.0
In-Reply-To: <84774cde4a948cb726db3bfcb463a04c.squirrel@intranet.cs.nmsu.edu>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
	 <45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
	 <0b055dc4810836e24ff21a776504142b.squirrel@intranet.cs.nmsu.edu>
	 <45a44e481003012249p6970d442o593af7d4971f0183@mail.gmail.com>
	 <84774cde4a948cb726db3bfcb463a04c.squirrel@intranet.cs.nmsu.edu>
Date: Wed, 3 Mar 2010 08:11:23 +0800
Message-ID: <45a44e481003021611g8572667yd5c135f3b3927fb3@mail.gmail.com>
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

On Tue, Mar 2, 2010 at 11:36 PM, Rick L. Vinyard, Jr.
<rvinyard@cs.nmsu.edu> wrote:
>
> Jaya Kumar wrote:
>> On Tue, Mar 2, 2010 at 12:10 AM, Rick L. Vinyard, Jr.
>> <rvinyard@cs.nmsu.edu> wrote:
>>> Jaya Kumar wrote:
>>
>> Being concerned about CPU utilization is a good thing. But say for
>> example, your USB ethernet driver or USB audio driver is taking a lot
>> of cpu time packetizing traffic, then would I be correct that your
>> desire is to expose an inter-packetization driver specific sleep time
>> controllable by userspace via sysfs for all ethernet, audio, etc
>> drivers? (by driver specific, I mean the sysfs parameter would be
>> presented by all drivers but the value would be specific to each one,
>> which is the way your current patch would behave for all fb drivers).
>>
>
> I think the answer is yes, whether this were a fb, network, audio, etc. If
> there is a clearly defined parameter at which resource utilization can be
> adjusted in a standard way.

Hi Rick,

Sure, we can find these driver resource utilization choke points, and
maybe even make it sort of standard, but that does not mean that we
should expose all of this to userspace. Adding more userspace tunables
for each driver in order to effect fb, network, audio bus utilization,
is not appealing. So I think we disagree about the fundamentals.

My conclusion is: I'm opposed this patch, because it exposes the defio
delay parameter for _all_ fb drivers, _each_ through a
/sys/class/graphics/fb_driver_name/defio_delay sysfs entry and also
adds a min/max issue. The behaviour and system impact seen by
userspace when changing the parameter is not standard across the
typical range of systems and devices. More importantly, exposing each
driver's defio delay to userspace is not a good way to address the 2
underlying functional goals that were raised during this discussion:
1) being able to control a driver's bus/cpu utilization, and 2)
allowing certain plugins/etc to be able to increase display update
frequency for subregions of the display.

Just to be verbose, please don't let my rejection of this specific
patch affect your other patches as I see those as being very useful
and close to being suitable for merging.

Thanks,
jaya
