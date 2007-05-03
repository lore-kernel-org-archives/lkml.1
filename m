Return-Path: <linux-kernel-owner+w=401wt.eu-S1161847AbXECLD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161847AbXECLD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161846AbXECLD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:03:27 -0400
Received: from rex.snapgear.com ([203.143.235.140]:44346 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161845AbXECLDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:03:10 -0400
Message-ID: <4639C164.5070908@snapgear.com>
Date: Thu, 03 May 2007 21:03:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
References: <46382055.8030203@snapgear.com> <200705020458.06595.rgetz@blackfin.uclinux.org> <463876BA.9020005@snapgear.com> <200705030655.36957.rgetz@blackfin.uclinux.org>
In-Reply-To: <200705030655.36957.rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote:
> On Wed 2 May 2007 07:32, Greg Ungerer pondered:
>> Robin Getz wrote:
>>> On Wed 2 May 2007 01:23, Greg Ungerer pondered:
>>>> diff -Naur linux-2.6.21/fs/namei.c linux-2.6.21-uc0/fs/namei.c
>>>> --- linux-2.6.21/fs/namei.c     2007-05-01 17:12:53.000000000 +1000
>>>> +++ linux-2.6.21-uc0/fs/namei.c 2007-05-01 17:16:18.000000000 +1000
>>>> @@ -120,12 +120,14 @@
>>>>         int retval;
>>>>         unsigned long len = PATH_MAX;
>>>>
>>>> +#ifdef CONFIG_MMU
>>>>         if (!segment_eq(get_fs(), KERNEL_DS)) {
>>>>                 if ((unsigned long) filename >= TASK_SIZE)
>>>>                         return -EFAULT;
>>>>                 if (TASK_SIZE - (unsigned long) filename < PATH_MAX)
>>>>                         len = TASK_SIZE - (unsigned long) filename;
>>>>         }
>>>> +#endif
>>>>
>>>>         retval = strncpy_from_user(page, filename, len);
>>>>         if (retval > 0) {
>>> I was trying to understand why we don't want to do the same checking on
>>> noMMU?
>> The problem is on systems that have RAM mapped at high physical
>> addresses. TASK_SIZE may well be a numerically smaller number
>> than the address range that RAM sits in. So this test fails when
>> it shouldn't.
> 
> So, then this is a problem only on one or two architectures, not all noMMU 
> platforms?

Its not an architecture problem. It can effect any board that
has RAM mapped at a large numerical addresses (larger than TASK_SIZE).
So it can effect any non-MMU platform.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
