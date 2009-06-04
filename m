Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbZFDKz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbZFDKz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZFDKzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:55:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:22284 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbZFDKzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YG0JkPgc6PF8kYl/glO4OzWzCK/vFPL8K30LwVRAy/SRRanOYh2qtmkljicUM/YbxX
         4Y23s6izOvrrcIhHB8rqMshgTjVkQMjET6WJJxNcFKEByqcVe90XdHc4PXNnoUj4pCwY
         uC+Ucdpy3nSDbk4lvWGco4NWg+v258IM9R92k=
MIME-Version: 1.0
In-Reply-To: <20090604113504.5370775b@hyperion.delvare>
References: <4A278C08.5000206@samsung.com>
	 <5d5443650906040216h2314b7bbt1ae2e89c709b566e@mail.gmail.com>
	 <20090604113504.5370775b@hyperion.delvare>
Date: Thu, 4 Jun 2009 19:55:13 +0900
Message-ID: <1f3430fb0906040355y21d5c8d1u4133dd8f7f4e9d70@mail.gmail.com>
Subject: Re: [PATCH v2] add MAX17040 Fuel Gauge driver
From: Minkyu Kang <promsoft@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Anton Vorontsov <cbou@mail.ru>,
       linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear, Jean Delvare

>
> In case of error, this will wrap the error code into a u8 and the
> caller won't notice. So you'll return a random value, depending on the
> actual error which happened. No good.
>
> You should either return an int there, and have the caller check for
> errors, or if you don't want to care about errors, return an arbitrary
> value on error (e.g. 0.)
>

Yes, I missed it.

>> > +       ret = power_supply_register(&client->dev, &bat_ps);
>> > +       if (ret) {
>> > +               dev_err(&max17040->client->dev,
>> > +                               "failed: power supply register\n");
>> > +               cancel_delayed_work(&chip->work);
>> > +               i2c_set_clientdata(client, NULL);
>> > +               kfree(chip);
>> > +               max17040 = NULL;
>> > +               return -1;
>
> Please come up with a better error code.
>

Ok, many thanks :)

-- 
from. prom.
promsoft.net
