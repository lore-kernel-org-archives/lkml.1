Return-Path: <linux-kernel-owner+w=401wt.eu-S1764137AbXHGMOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764137AbXHGMOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbXHGMON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:14:13 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4644 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbXHGMOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:14:11 -0400
Message-ID: <46B86215.1020902@shadowen.org>
Date: Tue, 07 Aug 2007 13:14:13 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andy Whitcroft <apw@shadowen.org>, Thomas Renninger <trenn@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ACPI modpost failure in 2.6.23-rc1-git2
References: <20070806114335.GA31368@shadowen.org> <6bffcb0e0708060453l372e15c2h703ede437b4d8935@mail.gmail.com> <46B74546.2090501@shadowen.org>
In-Reply-To: <46B74546.2090501@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Michal Piotrowski wrote:
>> Hi Andy,
>>
>> On 06/08/07, Andy Whitcroft <apw@shadowen.org> wrote:
>>> Between 2.6.23-rc1-git1 and 2.6.23-rc1-git2 we started getting the
>>> following fatal error during modpost on an x86_64 machine:
>>>
>>>   FATAL: drivers/acpi/video: sizeof(struct acpi_device_id)=20 is not a
>>>   modulo of the size of section __mod_acpi_device_table=48.
>>>   Fix definition of struct acpi_device_id in mod_devicetable.h
>>>   make[1]: *** [__modpost] Error 1
>>>
>>> This check seems to have been added as part of the following commit:
>>>
>>>   commit 29b71a1ca74491fab9fed09e9d835d840d042690
>>>   Author: Thomas Renninger <trenn@suse.de>
>>>   Date:   Mon Jul 23 14:43:51 2007 +0200
>>>
>>>       ACPI: autoload modules - Create ACPI alias interface
>>>
>>> Compiler version:
>>>   Reading specs from /usr/lib/gcc/i486-linux/3.4.4/specs
>>>   Configured with: ../src/configure -v
>>>   --enable-languages=c,c++,java,f77,pascal,objc,ada,treelang --prefix=/usr
>>>   --libexecdir=/usr/lib --with-gxx-include-dir=/usr/include/c++/3.4
>>>   --enable-shared --with-system-zlib --enable-nls
>>>   --without-included-gettext --program-suffix=-3.4 --enable-__cxa_atexit
>>>   --enable-libstdcxx-allocator=mt --enable-clocale=gnu
>>>   --enable-libstdcxx-debug --enable-java-gc=boehm --enable-java-awt=gtk
>>>   --disable-werror i486-linux
>>>   Thread model: posix
>>>   gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13sarge1)
>>>
>>> We are compiling a 64bit kernel on a machine with a pretty old
>>> userspace which is 32bit.
>>>
>>> Let me know if you need more info.
>>>
>>> -apw
>> similar to
>>
>> Subject         : modpost bug breaks ia64 cross compilation
>> References      : http://lkml.org/lkml/2007/7/27/30
>>                   http://lkml.org/lkml/2007/7/27/418
>> Last known good : ?
>> Submitter       : Jan Dittmer <jdi@l4x.org>
>> Caused-By       : Thomas Renninger <trenn@suse.de>
>>                   commit 29b71a1ca74491fab9fed09e9d835d840d042690
>> Handled-By      : ?
>> Patch           : http://lkml.org/lkml/2007/8/2/211
>> Status          : patch was suggested
>>
>> Please try this patch http://lkml.org/lkml/2007/8/2/211
> 
> Will do.  That is vile though.
> 
> It feels like we should be generating this information in the kernel
> build and extracting it from the built kernel.

Confirmed that this patch does indeed fix up my problem machine.

Its very ugly but it does work.

-apw
