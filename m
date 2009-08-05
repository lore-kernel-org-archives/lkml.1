Return-Path: <linux-kernel-owner+w=401wt.eu-S934173AbZHEKo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173AbZHEKo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbZHEKo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:44:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:4627 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424AbZHEKo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bAXt5r5EMRGpA/ReXFWc+RcDpuFgzfkWVYfM4YtYrOQud3t8dvxMgnnpv1hnenHTIW
         cftWaBPiH6zZlJySrjXbeIxhKh5QnEuMVQUx9bT7HifW2eJrhxURnZIUSArlihy5ogIV
         nTpnEFMHYub8SPI/3kLXQH8EQS8WdsQ/arl14=
MIME-Version: 1.0
In-Reply-To: <20090805103127.GF30892@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com>
	 <20090804201032.GB30892@infomag.iguana.be>
	 <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com>
	 <20090805070822.GC30892@infomag.iguana.be>
	 <e68bb3470908050100n4f6f8ed3hbd227a13e038e55f@mail.gmail.com>
	 <20090805103127.GF30892@infomag.iguana.be>
Date: Wed, 5 Aug 2009 18:44:57 +0800
Message-ID: <e68bb3470908050344u73cdb1c0o3257febee77d9f9f@mail.gmail.com>
Subject: Re: [PATCH] Add watchdog driver for w90p910
From: Wan ZongShun <mcuos.com@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wim,


2009/8/5, Wim Van Sebroeck <wim@iguana.be>:
> Hi Wan,
>
> > > I have an additional question: which timeout values can you set? is it 0, 1, 2 and 3 seconds?
> >
> > The 0, 1, 2 and 3 is not seconds, rather than 'level' , it means my
> > watchdog controller can only set four grades,
> > When WTIS bit of REG_WTCR was set one value of  the 0, 1, 2 and 3, the
> >  real time interval can be calculated via following formula .
> >
> > WTIS                 real time interval (formula)
> > 0x00                   ((2^ 14 ) * ((external crystal freq) / 256))seconds
> > 0x01                   ((2^ 16 ) * ((external crystal freq) / 256))seconds
> > 0x02                   ((2^ 18 ) * ((external crystal freq) / 256))seconds
> > 0x03                   ((2^ 20 ) * ((external crystal freq) / 256))seconds
> >
> > The external crystal freq is 15Mhz in w90p910 evaluation board. so I
> > set the '0x00' as a default value, it means the real time interval is
> > 0.28 second approximately.
>
> Hmm, the watchdog API works in seconds.
> A timer will need to be used like in similar watchdog drivers (like at91sam9_wdt.c, pcwd.c).

Do you mean that we should provide userspace a setting seconds api?
it like following:

ioctl(fd, WDIOC_SETTIMEOUT,&value);

the value must be seconds?

Hmm, but the w90p910 only provides four grades seconds setting, rather
than all seconds time can be set, if so, how to write the wdt driver
so that the patch can be accepted for you?any idea?

>
> Kind regards,
> Wim.
>
>


-- 
Wan z.s
