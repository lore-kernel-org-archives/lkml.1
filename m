Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbZJGOYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbZJGOYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759218AbZJGOYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:24:12 -0400
Received: from mga06.intel.com ([134.134.136.21]:25059 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758524AbZJGOYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:24:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,519,1249282800"; 
   d="scan'208";a="455284477"
Message-ID: <4ACCA44B.3070706@linux.intel.com>
Date: Wed, 07 Oct 2009 07:23:07 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: linux-kernel@vger.kernel.org, Adam Belay <abelay@novell.com>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.32-rc3: floating-point build failure (undefined reference
 to	`__udivdi3' in menu governor)
References: <20091007104125.GA1449@rhlx01.hs-esslingen.de>
In-Reply-To: <20091007104125.GA1449@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> Hi,
> 
> didn't find any report about this, so...
> 
>   LD      .tmp_vmlinux1
> drivers/built-in.o(.text+0xd85a1): In function `menu_select':
> drivers/cpuidle/governors/menu.c:212: undefined reference to `__udivdi3'
> make: *** [.tmp_vmlinux1] Error 1
> 
> # gcc -v
> Reading specs from /usr/lib/gcc-lib/i386-redhat-linux/3.2.3/specs
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --enable-shared --enable-threads=posix --disable-checking --with-system-zlib --enable-__cxa_atexit --host=i386-redhat-linux
> Thread model: posix
> gcc version 3.2.3 20030502 (Red Hat Linux 3.2.3-49)

seems you're the only user of this left.

it's not floating point but a 64 bit division.
The only one I can imagine is the one on line 213

looking at it, can you try sticking (u32) at the end of line 212; that multiply is not very likely to exceed 32 bits


