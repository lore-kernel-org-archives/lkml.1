Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYB2SG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYB2SG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbYB2SGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:06:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:15924 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbYB2SGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:06:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LZKOef9EqZavG3Si2+D87vw09Ji3dDYluBX6nsj7iZUNrQCvJ1tBPFwZiq+xE9vzQlzcgFH6WF5pijnp13zWe5406nD0mMCZ9c+j0+23AewnM6fGO8Y2+inrbozHfZo9e0gcn9qEU5mTKqPuhsC7l8AEpqcsglDfSqKwwqlNA38=
Message-ID: <47C849B8.1000902@googlemail.com>
Date: Fri, 29 Feb 2008 19:06:48 +0100
From: Mark Pearson <devnull.port@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Karol Kozimor <sziwan@hell.org.pl>, Julia Lawall <julia@diku.dk>,
       corentincj@iksaif.net, sziwan@users.sourceforge.net,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/9] drivers/acpi/asus_acpi.c: Correct use of ! and &
References: <Pine.LNX.4.64.0802262142120.18200@ask.diku.dk>	<7C626792-02A6-4BE6-B5F2-D75899F3990C@hell.org.pl>	<47C5ABFB.3050607@googlemail.com> <20080228215503.b942bb3c.akpm@linux-foundation.org>
In-Reply-To: <20080228215503.b942bb3c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> Seems an odd way of doing:
>>
>> 	led_out ^= 0x01;
> 
> It does.
> 
>> It this due to some optimisation?
> 
> Surely not ;)
>
;) Thought so - one doesn't like to be too presumptuous ;)

> That code has been there for many years.
> 
> I changed the patch to this:
> 
> --- a/drivers/acpi/asus_acpi.c~drivers-acpi-asus_acpic-correct-use-of-and
> +++ a/drivers/acpi/asus_acpi.c
> @@ -610,7 +610,7 @@ write_led(const char __user * buffer, un
>  	    (led_out) ? (hotk->status | ledmask) : (hotk->status & ~ledmask);
>  
>  	if (invert)		/* invert target value */
> -		led_out = !led_out & 0x1;
> +		led_out = !led_out;
>  
>  	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
>  		printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
> _
> 
> 

Is the ! operator architecture/compiler dependent? or can one always say that
!NON_ZERO_VALUE == 0 and !0 == 1?

Cheers, Mark.
