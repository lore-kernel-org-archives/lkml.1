Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZIAJeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZIAJeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 05:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZIAJeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 05:34:05 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:42847 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbZIAJeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 05:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qzIwnhhnlPqU6z8KtjQhLD3TJDTQS+t/cguMBtsdnBnUWrbyJk1BTX3tXN4aZH9kU4
         2kU6vcmnNcF8RSnW1ua4rTju0i1ZlERML6FryopBh+ZxjgMC5mqRGYZU5tjA7rYkWKlm
         C5rOTTorhgLoHjoYUfAB9J0LkkKSbij75jnSI=
MIME-Version: 1.0
In-Reply-To: <200908312119.12121.rjw@sisk.pl>
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com>
	 <200908312119.12121.rjw@sisk.pl>
Date: Tue, 1 Sep 2009 11:34:04 +0200
Message-ID: <c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/31 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday 31 August 2009, Zdenek Kabelac wrote:
>> Hi
>>
>> I've noticed that my machine freezes while doing s2r and having
>> mounted filesystem from SD card.
>>
>> My system: Lenovo T61, 4GB, C2D, kernel 2.6.31-rc8
>>
>> Here is the trace of  suspend when SD card is inserted, follows resume
>> and again suspend and this time with mounted filesystem from SD card.
>>
>> System locks with: PM: Removing info for mmc:mmc0:b368
>> Also btusb_bulk_complete: errors are interesting - I've noticed few
>> bugzillas in the google.
>> I could try bisect to find the patch - but it will take time....
>> So hopefully this trace will help.
>
> Not really. :-(
>
> Is this a new regression in 2.6.31-rc, or does 2.6.30 also fail?
>

Well - all I know for now is this:  v2.6.30 goes to suspend (i.e.
machine turns to sleep), but resume fails - I do not get a single line
of output on serial console either - so it's hard to tell whether it
works or not - before suspend there are some INFO traces about lockdep
problems in cpu frequency.   v2.6.31-rc1 doesn't boot on my machine.
v2.6.31-rc2 seems to lock on suspend so this version is already
definitely broken. I may try to do some bisecting between these
kernels - but it might probably easily lead to some dead-ends probably
:(...
Also I'm using  mmc debugs for compilation of these kernels - but
nothing seems to printed from mmc subsystem at the end of suspend log
and the end is still the same - last printed lines:

 mmc0: card b368 removed
 PM: Removing info for mmc:mmc0:b368

Zdenek
