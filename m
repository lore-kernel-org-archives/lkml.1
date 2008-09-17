Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYIQTqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYIQTqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYIQTqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:46:08 -0400
Received: from h155.mvista.com ([63.81.120.155]:50379 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752460AbYIQTqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:46:05 -0400
Message-ID: <48D15EAD.1030804@ru.mvista.com>
Date: Wed, 17 Sep 2008 23:46:53 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zev Weiss <zevweiss@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [MTD] physmap.c: Check return of	platform_device_register()
References: <48CB5E9A.4010000@gmail.com> <20080917115746.e36cacc6.akpm@linux-foundation.org> <48D15DC8.60307@ru.mvista.com>
In-Reply-To: <48D15DC8.60307@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just wrote:

>>> The PHYSMAP_COMPAT code had been ignoring the return value of
>>> platform_device_register() in the physmap_init() function.

>>> Signed-off-by: Zev Weiss <zevweiss@gmail.com>

> [...]

>>> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
>>> index 42d844f..6fba0d4 100644
>>> --- a/drivers/mtd/maps/physmap.c
>>> +++ b/drivers/mtd/maps/physmap.c
>>> @@ -312,7 +312,7 @@ static int __init physmap_init(void)
>>>      err = platform_driver_register(&physmap_flash_driver);
>>>  #ifdef PHYSMAP_COMPAT
>>>      if (err == 0)
>>> -        platform_device_register(&physmap_flash);
>>> +        err = platform_device_register(&physmap_flash);
>>>  #endif
>>>
>>>      return err;

[...]

>> Presumably we should run platform_driver_unregister() if the
>> platform_device_register() failed.

>    Why is that? There could be "normal" platform devices out there...

   With that said, the patch is pointless (as already noted by Lennert).

WBR, Sergei
