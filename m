Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYGRJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYGRJSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbYGRJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:18:09 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:17419 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYGRJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MMYGGOr4YqhJCnK487zCwiJOdMhKMEhtCrEWBZN3R5gt08IgHflezV6nF7DNfjgT4S
         hWyfdzrtlzx2IQA3RhLxLS0UFe0ScsyZpcMM3agklZlSE7+oMSWbOOPZNBwabRstE7Tx
         7nTzEqN7bKtgqu7txuPhGq7PIa5z3RpM6ykw0=
Message-ID: <aec7e5c30807180218y1911d3d3h2e80f5a097a79a14@mail.gmail.com>
Date: Fri, 18 Jul 2008 18:18:06 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [PATCH 04/05] i2c-sh_mobile: IORESOURCE_CLK support
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, gregkh@suse.de,
       lethal@linux-sh.org, i2c@lm-sensors.org, akpm@linux-foundation.org
In-Reply-To: <20080718080457.GM24620@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
	 <20080718074036.32713.92629.sendpatchset@rx1.opensource.se>
	 <20080718080457.GM24620@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 5:04 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Fri, Jul 18, 2008 at 04:40:36PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> This patch makes the i2c-sh_mobile driver get the clock name from the
>> struct resource with type IORESOURCE_CLK provided by the platform data.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>> ---
>>
>>  drivers/i2c/busses/i2c-sh_mobile.c |    8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> --- 0001/drivers/i2c/busses/i2c-sh_mobile.c
>> +++ work/drivers/i2c/busses/i2c-sh_mobile.c   2008-07-18 14:56:40.000000000 +0900
>> @@ -390,13 +390,19 @@ static int sh_mobile_i2c_probe(struct pl
>>       int size;
>>       int ret;
>>
>> +     res = platform_get_resource(dev, IORESOURCE_CLK, 0);
>> +     if (res == NULL || res->name == NULL) {
>> +             dev_err(&dev->dev, "cannot find CLK resource\n");
>> +             return -ENOENT;
>> +     }
>> +
>>       pd = kzalloc(sizeof(struct sh_mobile_i2c_data), GFP_KERNEL);
>>       if (pd == NULL) {
>>               dev_err(&dev->dev, "cannot allocate private data\n");
>>               return -ENOMEM;
>>       }
>>
>> -     pd->clk = clk_get(&dev->dev, "peripheral_clk");
>
> I think that is working correctly and there isn't really any
> need to change this. The clk_get is supplied the device that
> it needs the clock for, and the name of the clock needed.

Right, we could handle this "under the hood" of the clock frame work
implementation, or we could deal with it together with the rest of the
platform data and have one unique string per hardware block. On SuperH
Mobile we currently have one shared clock implementation that supports
multiple processors. Which clock that is assigned to what hardware
block is currently handled by per-cpu platform data, and that's where
this patch comes in.

Thanks!

/ magnus
