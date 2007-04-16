Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbXDPVeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbXDPVeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbXDPVeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:34:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:23942 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbXDPVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=AZJ3HFaIl1+bwIitaBpTLEmwU4W9QOkTJukJ8L5ertI0LYViQpm+AxZMShUGnwTaiv4FZZbo9heweeLQ6SGF29Ma+7qAQDw0vB5Fp5U++07i34P054qrxAvwPr4U6WZeygOeYe9RdcX3gZlxC2qjL8h6vchBb7xXUALM1cwFBzE=
Date: Tue, 17 Apr 2007 00:34:48 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1991922844.20070417003448@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
       <kernel-discuss@handhelds.org>
Subject: Re: [Kernel-discuss] Re: [PATCH 7/7] [RFC] APM emulation driver for class batteries
In-Reply-To: <20070416202421.GC19713@flint.arm.linux.org.uk>
References: <20070411232644.GG20095@zarina> <20070413135005.GE20618@zarina> <20070416202421.GC19713@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

Monday, April 16, 2007, 11:24:21 PM, you wrote:

> On Fri, Apr 13, 2007 at 05:50:43PM +0400, Anton Vorontsov wrote:
>> +static void (*old_apm_get_power_status)(struct apm_power_info*);
>> +
>> +static int __init apm_battery_init(void)
>> +{
>> +     printk(KERN_INFO "APM Battery Driver\n");
>> +
>> +     old_apm_get_power_status = apm_get_power_status;
>> +     apm_get_power_status = apm_battery_apm_get_power_status;
>> +     return 0;
>> +}
>> +
>> +static void __exit apm_battery_exit(void)
>> +{
>> +     apm_get_power_status = old_apm_get_power_status;
>> +     return;
>> +}

> Utterly unsafe.  What happens if some other module gets loaded which
> does this, and then this module is unloaded followed by the other
> module.  Result: Oops.

	That's apparently why "APM emulation" goes on its way towards deprecation, right? And why people so detailed about new battery API, as it's everyone's hope that it should replace APM.

	We exactly provide APM emulation on top of battery API as separate driver because of such issues with APM API. Anyway, any suggestions on solving this "pointer API" issue? Would at least assigning NULL on exit be more safe? (Because yes, there just shouldn't be two APM drivers, and for the weird case there're, it would be nice to at least not segfault.)



-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

