Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZALKk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZALKk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZALKkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:40:19 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:55564 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZALKkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:40:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dUjYxfovIbg9Lzj/t4VtQlle0FgnuoU8D008YZosMYFilJsYt/issyxk68C2F5mnUO
         WcRoobSHHB633J+JDbdTRl/3bHMmsXX+HKhowHn+naKklBdWyT1mtUg4YvZoSpgSu8Sy
         LHNtpzaEYO1XkBwMdYQcT7Uwyw1nta4CTt5mA=
Message-ID: <a4423d670901120240m6ee29951ucc1c0f16c27d398c@mail.gmail.com>
Date: Mon, 12 Jan 2009 13:40:15 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.28-rc6: hpet: object is on stack, but not annotated
Cc: "Pavel Machek" <pavel@suse.cz>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       venkatesh.pallipadi@intel.com, shaohua.li@intel.com
In-Reply-To: <20081204111621.GA2466@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670811240839q54e6b7afxfc49d28b3ea127cb@mail.gmail.com>
	 <a4423d670811241014n2b2192beh931d374bf063894f@mail.gmail.com>
	 <alpine.LFD.2.00.0811241916560.3301@localhost.localdomain>
	 <20081204111621.GA2466@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/4 Pavel Machek <pavel@suse.cz>:
> On Mon 2008-11-24 19:17:44, Thomas Gleixner wrote:
>> On Mon, 24 Nov 2008, Alexander Beregalov wrote:
>>
>> > 2008/11/24 Alexander Beregalov <a.beregalov@gmail.com>:
>> > > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
>> > > hpet0: 3 comparators, 64-bit 14.318180 MHz counter
>> > > ODEBUG: object is on stack, but not annotated
>> > > ------------[ cut here ]------------
>> > > WARNING: at lib/debugobjects.c:251 __debug_object_init+0x2a4/0x352()
>> >
>> > Bisected down to 26afe5f2fbf06ea0765aaa316640c4dd472310c0
>> > (x86: HPET_MSI Initialise per-cpu HPET timers)
>> >
>> > Revert helps
>>
>> That's just a warning about a missing annotation. The commit is fine.
>
> You must be using very different metric of what "fine" means than rest
> of the world.
>
> (No, introducing WARN_ON()s is not fine; it spams kerneloops.org at least...)

The warning is still here on 2.6.29-rc1.
It taints the kernel.
