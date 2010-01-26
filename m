Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560Ab0AZLwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0AZLwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 06:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376Ab0AZLwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 06:52:07 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:52131 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0AZLv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 06:51:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BmkLSVormpiNwbdim5IIuBNhRuBYfLRugaXEMwhxZ9YyUihhcdoJ/65O2iuWsKsjBK
         Vudjv7T8y0fhnHFDGUTCw0S9rs3SXExig4yxZ7rluSjMmQ3wWpvKAh+KeAuMwZX9Gtyg
         pYNawETV6Un/oxJFNvMKiBbMDQ7RhWHDITZ0w=
MIME-Version: 1.0
In-Reply-To: <1264503701.3067.69.camel@odin>
References: <771cded01001120041ue24edabk8e4638ef7151c947@mail.gmail.com>
	 <771cded01001120051l44fd76bx80d2fd4b6f60bd0b@mail.gmail.com>
	 <20100112115156.GA546@rakim.wolfsonmicro.main>
	 <771cded01001250301q465a9f8ma484f597ae9a292f@mail.gmail.com>
	 <20100125135628.GB26613@rakim.wolfsonmicro.main>
	 <771cded01001252226k342723b3p3ea235fe79c46843@mail.gmail.com>
	 <1264503701.3067.69.camel@odin>
Date: Tue, 26 Jan 2010 06:51:59 -0500
Message-ID: <771cded01001260351w21af1448q9439fad3821c3c55@mail.gmail.com>
Subject: Re: [PATCH 01/01] regulator: support max8649
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 6:01 AM, Liam Girdwood <lrg@slimlogic.co.uk> wrote:
> On Tue, 2010-01-26 at 01:26 -0500, Haojian Zhuang wrote:
>> From 2b5a73c336d2b5dc48c8cf1f2a804b6968659f78 Mon Sep 17 00:00:00 2001
>> From: Haojian Zhuang <haojian.zhuang@marvell.com>
>> Date: Mon, 25 Jan 2010 10:24:09 -0500
>> Subject: [PATCH] regulator: enable max8649 regulator driver
>>
>> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
>
> Can you confirm all the changes compared to the last version.
>
Yes, exactly.

>> +static int max8649_get_voltage(struct regulator_dev *rdev)
>> +{
>> +       struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
>> +       unsigned char data;
>> +       int ret;
>> +
>> +       ret = max8649_reg_read(info->i2c, info->vol_reg);
>> +       if (ret < 0)
>> +               return ret;
>> +       data = (unsigned char)ret & MAX8649_VOL_MASK;
>> +       return (max8649_list_voltage(rdev, data));
>
> Any reason why we have extra () here ?
>
Fixed.
