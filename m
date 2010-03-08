Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0CHJ6d convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Mon, 8 Mar 2010 04:58:33 -0500
Received: from smtp-out.google.com ([216.239.33.17]:31776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab0CHJ6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:58:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=URgX7RDIHpyQiS3+N+yg3UeUZISB1Dh+rkPsFIOu+uoZsOtvEhlfG0FZJ1/68634E
	1JAxWJGKSypQODnFSNg8g==
MIME-Version: 1.0
In-Reply-To: <4B8F9727.6080907@cam.ac.uk>
References: <4B8C1867.7040201@cam.ac.uk>
	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
	 <20100303184132.GA11471@core.coreip.homeip.net>
	 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
	 <20100303190753.GB11471@core.coreip.homeip.net>
	 <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>
	 <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain>
	 <4B8F9727.6080907@cam.ac.uk>
Date: Mon, 8 Mar 2010 01:58:26 -0800
Message-ID: <404ea8001003080158w6a747cbfv9475e32976ccf9e2@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Dima Zavin <dmitriyz@google.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan,

> Anyhow, the way this conversation is going there appear to be several=
 options
> and we need to make a decision before anyone wastes much more time.
>
> 1) ALS as is. It's extremely light weight and can always be merged wi=
th a better
> =A0option at a later date. If people prefer we can always stick it in=
 a subdirectory
> =A0called sensors or similar. =A0Perhaps move hwmon in there as well.

If your plan is to integrate with iio when it's ready, then there will
be a drivers/iio, so creating top-level als or even drivers/sensors at
this point wouldn't really make sense. Perhaps putting them into
drivers/misc/als is more appropriate?

> 2) Input. =A0I agree with Dmitry here. =A0These devices are not withi=
n the scope as it
> =A0currently exists. =A0It can be done and there have been numerous d=
iscussions about
> =A0doing so in the past (with various sensor types) and each time it =
has been decided
> =A0that it isn't the right option. =A0Perhaps opinion on this has cha=
nged?

As Dmitry correctly distilled from my ramblings, what we really need
is support for poll() on sensor devices. If you guys add a poll
interface to als, then we can probably get by until iio gets merged.
Otherwise, we will still need to hack up an input device exporting
ABS_MISC. If we had ABS_AMBIENT_LIGHT_LEVEL, then it'd be slightly
less hacky.

> Please can anyone who feels like suggesting another general sensors s=
ubsystem
> at least taking a look at IIO (and keeping in mind we are in the midd=
le of a big
> API cleanup). =A0If you disagree with how we have done things, then c=
ontribute
> to the discussions and they may change.

I looked into IIO (sorry for the delay), and it does look promising.
I'll try to participate in future discussions, and will provide some
more feedback in a more appropriate forum as it is likely out of scope
here. When I get a chance, I'll try moving one of our drivers to iio
and see how it goes.

Thanks.

--Dima
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
