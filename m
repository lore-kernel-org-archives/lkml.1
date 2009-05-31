Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZEaBaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZEaBaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 21:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZEaB34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 21:29:56 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:52166 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZEaB3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 21:29:55 -0400
MIME-Version: 1.0
In-Reply-To: <20090530112221.GA1395@ucw.cz>
References: <1243408083.13460.14.camel@debian-nb>
	 <20090530112221.GA1395@ucw.cz>
Date: Sat, 30 May 2009 21:29:56 -0400
Message-ID: <f73f7ab80905301829j45723fd6j6e04904c8214e3b9@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Kyle Moffett <kyle@moffetthome.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       jwboyer@linux.vnet.ibm.com, grant.likely@secretlab.ca, paulus@samba.org,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 7:22 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index f430e15..b0ee851 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -158,6 +158,17 @@ config ARCH_MTD_XIP
>>  config GENERIC_HARDIRQS_NO__DO_IRQ
>>       def_bool y
>>
>> +config OF
>> +        def_bool y
>> +
>> +config PROC_DEVICETREE
>> +        bool "Support for device tree in /proc"
>
> It certainly should not be in /proc.

There is unfortunately a relatively large legacy base of existing
tools which depend on the device-tree (specifically, the
representation of the OF device tree that the kernel generates at
boot-time) present in proc, especially on platforms (PowerPC/Sparc)
which have a real OpenFirmware implementation.

On the other hand, since this is a new port, we can just assume that
(for this port) we're going to fix the tools to use a different path.

Cheers,
Kyle Moffett
