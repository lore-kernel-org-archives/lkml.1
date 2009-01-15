Return-Path: <linux-kernel-owner+w=401wt.eu-S935042AbZAOW7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935042AbZAOW7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761915AbZAOWpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:45:12 -0500
Received: from smtp-out.google.com ([216.239.45.13]:10037 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495AbZAOWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:45:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=hkXghJx+f+m1VRJglBjbpeekO5enx5mEk2FXYg4nVJFfD90K8LaphsEfgNaOOpjnC
	7hbNPsyDhRT59VbdiWfbw==
MIME-Version: 1.0
In-Reply-To: <1232046039.5966.54.camel@localhost.localdomain>
References: <200901051952.58029.bzolnier@gmail.com>
	 <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com>
	 <20090106073515.GY32491@kernel.dk> <4964866D.8010503@msgid.tls.msk.ru>
	 <1231342473.3282.19.camel@localhost.localdomain>
	 <496ECBA0.60209@gmail.com>
	 <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com>
	 <1232035561.5966.48.camel@localhost.localdomain>
	 <da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com>
	 <1232046039.5966.54.camel@localhost.localdomain>
Date: Thu, 15 Jan 2009 14:45:01 -0800
Message-ID: <da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
From: Grant Grundler <grundler@google.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.78
X-GMailtapped: grundler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:00 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
...
>> Code can test for zero/nonzero or (preferably) more fine grained.
>> e.g. "avgreadcost > 1ms" or "avgwritecost". I'm hoping this test
>> can be abstracted into a macro.
>
> Um these really have to be things we can get out of the device at boot
> time without effort (as in part of the data the device can give in a
> single command).  I'll be shot for increasing boot time so we can work
> out these parameters ...

No. The whole point is we should not care what it is at boot time.
It should be based on recent history of what is going on.
At boot time we read the partition table and we superblocks to mount
file systems.
That's fine to start with. So I don't see any need to add some synthetic test
to establish initial values.

The rest of the code should work regardless of what the values start out to be.
This is true for the previous proposed patch too when user space has
to decide what the right policy is.

>> I'm hoping longterm, the values could be "self tuning" but don't know
>> how that might work - e.g. 1 minute avg? 10 minute avg? Cost
>> of collecting/maintaining the stats? Feels like a CONFIG option.
>
> CONFIG_SLOW_YOUR_BOOT?

maybe CONFIG_AUTOTUNE_RWCOST.

thanks,
grant
