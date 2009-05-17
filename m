Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbZEQAhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbZEQAhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 20:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZEQAhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 20:37:04 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:35046 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZEQAhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 20:37:01 -0400
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905161636j5137717crdb72ea94e846d4b9@mail.gmail.com>
References: <4A0C43C3.9090404@pardus.org.tr> <20090515174056.GD29647@elte.hu> 
	<20090515210134.758f3123@i1501.lan.towertech.it> <20090516154912.a0efc677.akpm@linux-foundation.org> 
	<ac3eb2510905161636j5137717crdb72ea94e846d4b9@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 17 May 2009 02:36:41 +0200
Message-ID: <ac3eb2510905161736o1cb7bc2aub3b7355528c4f507@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [BUG 2.6.30_rc5] Null pointer dereference in 
	rtc-cmos driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, mingo@elte.hu,
       =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
       David Brownell <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 01:36, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Sun, May 17, 2009 at 00:49, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> This should fix the symptoms:
>
>> +++ a/drivers/rtc/rtc-cmos.c
>> @@ -1179,7 +1179,9 @@ static int __init cmos_init(void)
>>        int retval = 0;
>>
>>  #ifdef CONFIG_PNP
>> -       pnp_register_driver(&cmos_pnp_driver);
>> +       retval = pnp_register_driver(&cmos_pnp_driver);
>> +       if (retval < 0)
>> +               return retval;
>>  #endif
>
> That looks like a good fix.
>
>> Can someone please test it?
>
> I'll try to reproduce it.

Looks good. It makes the issue go away:
  Error: Driver 'rtc_cmos' is already registered, aborting...
  initcall cmos_init+0x0/0x55 [rtc_cmos] returned -17 after 51 usecs
  initcall cmos_init+0x0/0x55 [rtc_cmos] returned with error code -17

Now to the driver core fix to prevent that ...

Thanks,
Kay
