Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZAACfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZAACfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 21:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZAACfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 21:35:22 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:27516 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZAACfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 21:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xF8PdJyUiJOHCkny14HJlaHL4aUoZMreRPoHWwftE4CQSH19GPS7zCbn8K2Rp4FizZ
         hDAps6U5R4qe2QJTUgFPZuKgmpjE/H2uCvhSKes908N0g0zaS99VozgjB+WqZfWJC/ts
         d/2HzWjbZn/71D0oVKPgjMeWJoFvZKWjVJ6tU=
Message-ID: <b2b2f2320812311835t36b67cbdlba1fd6e537158c24@mail.gmail.com>
Date: Wed, 31 Dec 2008 20:35:18 -0600
From: "Shane McDonald" <mcdonald.shane@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH v4] Resurrect IT8172 IDE controller driver
Cc: alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <495B6080.7020802@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1LHrff-0007jd-Rp@localhost> <495B6080.7020802@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei,

On Wed, Dec 31, 2008 at 6:07 AM, Sergei Shtylyov
<sshtylyov@ru.mvista.com> wrote:
> Shane McDonald wrote:
>> Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Please forgive my ignorance -- this is my first non-trivial patch...
I have made a new patch incorporating your suggestions as described below.
Do I include your Acked-by line in my re-spun patch, or do I need you
to Ack it again?
I will post the new patch when I receive guidance on this.

>> diff -uprN a/drivers/ide/it8172.c b/drivers/ide/it8172.c
>> --- a/drivers/ide/it8172.c      1969-12-31 18:00:00.000000000 -0600
>> +++ b/drivers/ide/it8172.c      2008-12-30 20:55:29.000000000 -0600
>> +                                       { 7, 4 },
>> +                                       { 3, 3 },
>> +                                       { 2, 2 },
>> +                                       { 1, 2 }, };
>> +       /*
>> +        * The highest value of DIOR/DIOW pulse width and recovery time
>> +        * that can be set in the IT8172 is 8 PCI clock cycles.  As a
>> result,
>> +        * it cannot be configured for PIO mode 0.  This table sets these
>> +        * parameters to the maximum supported by the IT8172.
>> +        */
>
>  This comment seems somewhat mispalced...

I will move the comment before the timings array, where it belongs.

>> +       drive_timing &= drive->dn ? 0x00003f00 : 0x000fc000;
>> +       drive_timing |= ((timings[pio][0] << 11) | (timings[pio][1] << 8))
>> +                       << (drive->dn * 6);
>
>  This can be somewhat shortened:
>
>        drive_timing |= ((timings[pio][0] << 3) | timings[pio][1]) <<
>                        (drive->dn * 6 + 8);
>
>
>  Could've be shortened even more if timings[] was single-dimensional...

Good point!  I have made the array one-dimensional and shortened the
statement accordingly.

> MBR, Sergei

Shane
