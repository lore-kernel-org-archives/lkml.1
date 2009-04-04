Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZDDHSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZDDHSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 03:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZDDHSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 03:18:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:15597 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbZDDHSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 03:18:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r00ERLmzH0zCZDjSg7Zz9N4l0XbnO8/qgPpSUg6Hs4hI6MI2/cZy3Wk5TX8xMwCu6O
         vg0uRzl8l+qbGjGhNETXq3CuIZ1nZW0zaOgduMJiJY6goUpf1qtD8dwHoadhGEAeMR+f
         LavLMquTAb4yfQ4/UjDZIzFMH5eRgLCgxRuNw=
MIME-Version: 1.0
In-Reply-To: <20090404041740.GA6504@suse.de>
References: <20090328140049.GA4344@flint.arm.linux.org.uk>
	 <20090404041740.GA6504@suse.de>
Date: Sat, 4 Apr 2009 15:18:04 +0800
Message-ID: <d82e647a0904040018n6e5a261eodcb42d4bb76e65aa@mail.gmail.com>
Subject: Re: Commit 7a192ec is build breaking
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/4 Greg KH <gregkh@suse.de>:
> On Sat, Mar 28, 2009 at 02:00:49PM +0000, Russell King wrote:
>> The commit:
>>
>>     platform driver: fix incorrect use of 'platform_bus_type' with 'struct device_driver'
>>
>> contains this:
>>
>> -static int __exit pxa2xx_flash_remove(struct device *dev)
>> +static int __exit pxa2xx_flash_remove(struct platform_device *dev)
>> ...
>> -       .remove         = __exit_p(pxa2xx_flash_remove),
>> +       .remove         = __devexit_p(pxa2xx_flash_remove),
>>
>> which leads to the following build error:
>>
>> `pxa2xx_flash_remove' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
>>
>> This is not the only instance of it in this patch - all __exit_p's
>> touched by this patch have been converted to __devexit_p's without
>> regard to the original function.
>>
>> Let's revert this change and, if we are going to convert functions
>> to be __devexit/__devinit, lets have that as a _separate_ patch doing
>> just that change.
>
> Ick, Ming, any thoughts?  I'll revert your patch as it looks like it is
> incorrect in this way.

OK, revert the patch ,please.
I'll resend a patch to fix incorrect use of 'platform_bus_type' ,
which does not touch
__exit_p.

Thanks!

>
> thanks,
>
> greg k-h
>



-- 
Lei Ming
