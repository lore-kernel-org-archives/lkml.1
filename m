Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYKYRcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYKYRcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYKYRcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:32:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42601 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYKYRcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:32:02 -0500
Message-ID: <492C3687.1070304@zytor.com>
Date: Tue, 25 Nov 2008 09:31:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.28-rc2: x86_32 relocation regression?
References: <19f34abd0811241319u1abf5e77xc2359b4e8d17b518@mail.gmail.com>	 <1227576620.2442.7.camel@yhuang-dev.sh.intel.com> <19f34abd0811250207k3e0991bbgeaa41ccb48f4e4ac@mail.gmail.com>
In-Reply-To: <19f34abd0811250207k3e0991bbgeaa41ccb48f4e4ac@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> 
> Thanks!
> 
> It seems to be caused by this commit:
> 
> commit 5cb04df8d3f03e37a19f2502591a84156be71772
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Sun May 4 19:49:04 2008 +0200
> 
>     x86: defconfig updates
> 
> -CONFIG_PHYSICAL_START=0x100000
> -# CONFIG_RELOCATABLE is not set
> -CONFIG_PHYSICAL_ALIGN=0x100000
> ...
> +CONFIG_PHYSICAL_START=0x1000000
> +CONFIG_RELOCATABLE=y
> +CONFIG_PHYSICAL_ALIGN=0x200000
> 
> Were all changes intentional?
> 

Yes, but it's unacceptable that a relocatable kernel *NOT RELOCATED BY
THE BOOTLOADER* ends up with the debug information incorrect.  That is a
bug, plain and simple, and needs to be fixed.

	-hpa
