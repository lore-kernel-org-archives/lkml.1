Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbZJGRfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbZJGRfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZJGRff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:35:35 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60602 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZJGRff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:35:35 -0400
Date: Wed, 7 Oct 2009 19:34:58 +0200
From: Andreas Mohr <andi@lisas.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.32-rc3: floating-point build failure (undefined reference
	to `__udivdi3' in menu governor)
Message-ID: <20091007173457.GA25415@rhlx01.hs-esslingen.de>
References: <20091007104125.GA1449@rhlx01.hs-esslingen.de> <4ACCA44B.3070706@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACCA44B.3070706@linux.intel.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 07, 2009 at 07:23:07AM -0700, Arjan van de Ven wrote:
> Andreas Mohr wrote:
>> Hi,
>>
>> didn't find any report about this, so...
>>
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o(.text+0xd85a1): In function `menu_select':
>> drivers/cpuidle/governors/menu.c:212: undefined reference to `__udivdi3'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> # gcc -v
>> Reading specs from /usr/lib/gcc-lib/i386-redhat-linux/3.2.3/specs
>> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --enable-shared --enable-threads=posix --disable-checking --with-system-zlib --enable-__cxa_atexit --host=i386-redhat-linux
>> Thread model: posix
>> gcc version 3.2.3 20030502 (Red Hat Linux 3.2.3-49)
>
> seems you're the only user of this left.

Oh my...

> it's not floating point but a 64 bit division.
> The only one I can imagine is the one on line 213
>
> looking at it, can you try sticking (u32) at the end of line 212; that multiply is not very likely to exceed 32 bits

Nopeee.

        data->predicted_us = DIV_ROUND_CLOSEST((u32)
                data->expected_us * data->correction_factor[data->bucket],
                (u32)RESOLUTION * DECAY);

It did properly rebuild drivers/cpuidle/governors/menu.o.
Still happening.
IOW it must be somewhere inside the DIV_ROUND_CLOSEST macro or so.

Andreas Mohr
