Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYA1SHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYA1SHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYA1SHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:07:35 -0500
Received: from lucidpixels.com ([75.144.35.66]:48359 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYA1SHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:07:34 -0500
Date: Mon, 28 Jan 2008 13:07:33 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Jesse Barnes <jesse.barnes@intel.com>,
       Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
In-Reply-To: <20080128150957.GA12205@elte.hu>
Message-ID: <alpine.DEB.1.00.0801281307090.10823@p34.internal.lan>
References: <200801192045.17291.yinghai.lu@sun.com> <200801211209.23901.yinghai.lu@sun.com> <alpine.DEB.0.999999.0801211635480.6668@p34.internal.lan> <200801221950.06477.yinghai.lu@sun.com> <alpine.DEB.0.999999.0801251858450.4388@p34.internal.lan>
 <20080128150957.GA12205@elte.hu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jan 2008, Ingo Molnar wrote:

>
> * Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> Tried it, it worked successfully!
>>
>> With stock kernel, previous way I had to use it was mem=8832M and top
>> showed this:
>>
>> top - 18:53:52 up 1 min,  2 users,  load average: 1.03, 0.30, 0.10
>> Tasks: 169 total,   1 running, 168 sleeping,   0 stopped,   0 zombie
>> Cpu(s):  6.1%us,  2.6%sy,  4.5%ni, 81.3%id,  5.5%wa,  0.0%hi,  0.0%si,  0.0%st
>> Mem:   8039464k total,  1288948k used,  6750516k free,     3640k buffers
>> Swap: 16787768k total,        0k used, 16787768k free,   178528k cached
>>
>> With kernel you mentioned and use e820 v3:
>>
>> top - 18:48:13 up 3 min,  6 users,  load average: 1.67, 0.68, 0.25
>> Tasks: 195 total,   2 running, 193 sleeping,   0 stopped,   0 zombie
>> Cpu(s): 18.5%us,  1.2%sy,  1.6%ni, 74.8%id,  3.9%wa,  0.0%hi,  0.0%si,  0.0%st
>> Mem:   8037668k total,  1438732k used,  6598936k free,     6844k buffers
>> Swap: 16787768k total,        0k used, 16787768k free,   273928k cached
>>
>> No append mem= required.
>>
>> A full dmesg is attached so you can analyze the e820/MTRR mapping.
>
> thanks for testing it! The code indeed successfully trimmed your memory
> map by 64MB:
>
> from:
>
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000022c000000 (usable)
>
> to:
>
> [    0.000000]   modified: 0000000100000000 - 0000000228000000 (usable)
> [    0.000000]   modified: 0000000228000000 - 000000022c000000 (reserved)
>
> what happened on your box previously when you booted without any
> trimming - did it sometimes slow down or something like that?
>
> 	Ingo
>

When I boot the box without any trimming it acts like a 286 or 386, takes 
about 10 minutes to boot (using raptor disks).

Justin.
