Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0CCKal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:30:41 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:61475 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0CCKaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:30:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=T+lhOF9WxDytrzrNYJ5EERaq843tT2SmUW2N24YcUpBD0W5G00PIZRdUwJfScn0pbT
         A0tIAtGnsalcsnTjQAoY0rvAHFUx+1imoU8zjq7VBUz3LEF6QeFuJaKNDb8lwdzKH8DS
         Rgb7kPJabUvJjQH6keQwHz7E5SnrJYkCyVzrI=
MIME-Version: 1.0
In-Reply-To: <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
References: <4B8C1867.7040201@cam.ac.uk>
	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
Date: Wed, 3 Mar 2010 11:30:37 +0100
Message-ID: <63386a3d1003030230x2cc16e53udbacc9a5138f2872@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dima Zavin <dmitriyz@google.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/3 Dima Zavin <dmitriyz@google.com>:

> how does this deal with hybrid devices?

As any hybrid device, a drivers/mfd spawns multiple sensors, als,
accelerometer, voltage level, you name it.

> I definitely see the need for what you guys are trying to accomplish.
> For example, currently, we use an input device for reporting events,
> and a separate misc device node for control
> (enable/disable/configure). It's definitely suboptimal, but there
> currently isn't anything there would let us do things cleanly.

Are you registering your misc node from an mfd device then?

> I would love to work with you to design something more generic.

You can design forever, people need this now. (But we'd love
to see the patches!) It's better to refactor the day something
better is in place IMHO. Also I see no real clash. The userspace
interface will likely be the same (input subsystem) so what's the
problem?

In the drivers/staging/iio in the -next tree you can find something
more generic for industrial I/O including ADCs, triggers and
some sensors. I pointed out sometime last month that this
has the problem of exposing only userland interfaces and no
kernel-internal interfaces for the actual devices (just sysfs entries),
so the current ALS subsystem cannot fit into it, for example.

Linus Walleij
