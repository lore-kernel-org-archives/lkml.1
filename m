Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759254AbYLQHL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbYLQHL7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYLQHLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:11:48 -0500
Received: from smtp.nokia.com ([192.100.122.230]:33336 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYLQHLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:11:47 -0500
Message-ID: <4948A528.9090605@nokia.com>
Date: Wed, 17 Dec 2008 09:07:20 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Adrian Hunter <ext-adrian.hunter@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: linux-next: Tree for December 16
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au> <20081216152607.f232fafd.akpm@linux-foundation.org>
In-Reply-To: <20081216152607.f232fafd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Dec 2008 07:09:35.0329 (UTC) FILETIME=[6AC01510:01C96016]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Andrew Morton wrote:
> On Tue, 16 Dec 2008 22:37:54 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> I have created today's linux-next tree at
>> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
>> (patches at
>> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/)
> 
> This MTD patch:
> 
> commit 69423d99fc182a81f3c5db3eb5c140acc6fc64be
> Author:     Adrian Hunter <ext-adrian.hunter@nokia.com>
> AuthorDate: Wed Dec 10 13:37:21 2008 +0000
> Commit:     David Woodhouse <David.Woodhouse@intel.com>
> CommitDate: Wed Dec 10 13:37:21 2008 +0000
> 
>     [MTD] update internal API to support 64-bit device size
> 
> broke the i386 build:
> 
> ERROR: "__udivdi3" [drivers/mtd/devices/mtd_dataflash.ko] undefined!
> ERROR: "__umoddi3" [drivers/mtd/devices/mtd_dataflash.ko] undefined!
> ERROR: "__umoddi3" [drivers/mtd/devices/m25p80.ko] undefined!
> 
> because things like
> 
>                 pageaddr = instr->addr / priv->page_size;
> 
> are now doing a 64-bit divide.
> 
> These will all need to be hunted down and converted to do_div().

Right, I'll fix this shortly.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
