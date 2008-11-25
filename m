Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbYKYKHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbYKYKHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYKYKHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:07:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:21657 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYKYKHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:07:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RSIlcEzsNksYlDVkUmFrYtZDM4LPkq5tHnqQPGJy8ZG2Nx8Su4kWwfiijXF1pFCkyx
         E0cksAl1DlaHYMLeiCCHJdMmjQ04xzpVAo5/FYVYjUaKWJsM9ddzRVSF4Tzf3iCullhz
         gNIDDzIdz8AoC7tNBZ+IsfTFJdiWgH4OTExvg=
Message-ID: <19f34abd0811250207k3e0991bbgeaa41ccb48f4e4ac@mail.gmail.com>
Date: Tue, 25 Nov 2008 11:07:29 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Huang Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: v2.6.28-rc2: x86_32 relocation regression?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1227576620.2442.7.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0811241319u1abf5e77xc2359b4e8d17b518@mail.gmail.com>
	 <1227576620.2442.7.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 2:30 AM, Huang Ying <ying.huang@intel.com> wrote:
> Hi, Vegard,
>
> On Tue, 2008-11-25 at 05:19 +0800, Vegard Nossum wrote:
> [...]
>> It looks like everything was offset by 0xe00000:
>>
>>     $ addr2line -e vmlinux c119e613
>>     arch/x86/lib/string_32.c:20
>
> Because relocation is supported in recent Linux kernel, it is possible
> that the run-time address is different with compile-time address. In
> most cases, the kernel will be loaded into 0x100000 during boot, so the
> kernel run-time address range from 0xc0100000 on. But it seems that your
> kernel compile-time address range from 0xc0f00000 on. Please check
> CONFIG_PHYSICAL_START in your .config. In most cases, it will be set to
> 0x100000, so that it is same as run-time address in most cases.

Thanks!

It seems to be caused by this commit:

commit 5cb04df8d3f03e37a19f2502591a84156be71772
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun May 4 19:49:04 2008 +0200

    x86: defconfig updates

-CONFIG_PHYSICAL_START=0x100000
-# CONFIG_RELOCATABLE is not set
-CONFIG_PHYSICAL_ALIGN=0x100000
...
+CONFIG_PHYSICAL_START=0x1000000
+CONFIG_RELOCATABLE=y
+CONFIG_PHYSICAL_ALIGN=0x200000

Were all changes intentional?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
