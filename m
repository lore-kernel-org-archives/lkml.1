Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYHXPvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYHXPvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYHXPu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:50:58 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:44169 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbYHXPu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:50:57 -0400
Message-ID: <48B18361.6000305@lwfinger.net>
Date: Sun, 24 Aug 2008 10:50:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help with compiler warning
References: <48AE1802.5090301@lwfinger.net> <48B17E56.3060106@panasas.com> <48B17EE0.2090608@panasas.com>
In-Reply-To: <48B17EE0.2090608@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy wrote:
> On Aug. 24, 2008, 18:29 +0300, Benny Halevy <bhalevy@panasas.com> wrote:
>> On Aug. 22, 2008, 4:36 +0300, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> In drivers/pcmcia/cardbus.c, the following statement
>>>
>>>          memcpy_fromio(ptr, s->cb_cis_virt + addr, len);
>>>
>>> generates the warning
>>>
>>>    CC [M]  drivers/pcmcia/cardbus.o
>>> include/asm/io_32.h: In function ‘memcpy_fromio’:
>>> include/asm/io_32.h:151: warning: passing argument 2 of ‘__memcpy’ 
>>> discards qualifiers from pointer target type
>>>
>>> s->cb_cis_virt is "void __iomem" and addr is uint.
>>>
>>> What cast does argument 2 need to silence the warning?
>> memcpy_fromio takes a (const volatile void __iomem *) for the 
>> src address.
> 
> So the culprit could be the volatile qualifier...

Changing it to

memcpy_fromio(ptr, (const volatile void __iomem *)(s->cb_cis_virt + 
addr), len);

memcpy_fromio(ptr, (const volatile void __iomem *)s->cb_cis_virt + 
addr, len);

memcpy_fromio(ptr, (volatile void __iomem *)(s->cb_cis_virt + addr), len);

or

memcpy_fromio(ptr, (volatile void __iomem *)s->cb_cis_virt + addr, len);

makes no difference.

Thanks,

Larry
