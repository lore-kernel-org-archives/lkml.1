Return-Path: <linux-kernel-owner+w=401wt.eu-S1751803AbZHXHOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbZHXHOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZHXHOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:14:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37557 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZHXHOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:14:18 -0400
Message-ID: <4A923D98.4090501@zytor.com>
Date: Mon, 24 Aug 2009 00:13:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix build with older binutils and	 consolidate	
 linker script
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com> <4A8F0228.80805@zytor.com> <4A92557002000078000113DD@vpn.id2.novell.com>
In-Reply-To: <4A92557002000078000113DD@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2009 11:55 PM, Jan Beulich wrote:
>>>> "H. Peter Anvin" <hpa@zytor.com> 21.08.09 22:23 >>>
>> On 08/18/2009 08:51 AM, Jan Beulich wrote:
>>>  
>>>  #define VSYSCALL_ADDR (-10*1024*1024)
>>> -#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
>>> -                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
>>> -#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
>>> -                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
>>> +#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + SIZEOF(.data) + \
>>> +                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
>>> +#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + SIZEOF(.data) + \
>>> +                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
>>>  
>> I'm missing something with this chunk... could you please explain?
> 
> There are two changes here: One is the adjustment to properly use the
> new preceding section's name, and the other is to replace the hard coded
> 4095 by PAGE_SIZE-1.
> 

Hm.  I'm wondering if an actual (NOLOAD)/@nobits section wouldn't be
better...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

