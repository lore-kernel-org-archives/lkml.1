Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYB0S3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYB0S3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYB0S3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:29:09 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:15824 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbYB0S3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:29:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=eqCo1Uw0YLDhNbtnJVxD9UOoKQrN/h00mCK3jsgT4A7blWf4aDzkFadXp18ed4KdcwaJ2chSk4vm5Wx3ZPHoMhgS7Sf2rusF1ZsG7p4cykJv6zFjgKID4owPb0kEa4O0MYEClneph4+nqNKQAnERnwU/0+gzsKF/5ow4pE/RMgU=
Message-ID: <47C5ABFB.3050607@googlemail.com>
Date: Wed, 27 Feb 2008 19:29:15 +0100
From: Mark Pearson <devnull.port@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Karol Kozimor <sziwan@hell.org.pl>
CC: Julia Lawall <julia@diku.dk>, corentincj@iksaif.net,
       sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/9] drivers/acpi/asus_acpi.c: Correct use of ! and &
References: <Pine.LNX.4.64.0802262142120.18200@ask.diku.dk> <7C626792-02A6-4BE6-B5F2-D75899F3990C@hell.org.pl>
In-Reply-To: <7C626792-02A6-4BE6-B5F2-D75899F3990C@hell.org.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Kozimor wrote:
> On 26-02-2008, at 21:42, Julia Lawall wrote:
>>      if (invert)        /* invert target value */
>> -        led_out = !led_out & 0x1;
>> +        led_out = !(led_out & 0x1);
>>
>>      if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
>>          printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
> 
> 
> IIRC we're just supposed to flip the last bit here, so the original code
> is correct.
> Best regards,
> 

Seems an odd way of doing:

	led_out ^= 0x01;

It this due to some optimisation?

Cheers, Mark.
