Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbZLEGR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbZLEGR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 01:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZLEGRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 01:17:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZLEGRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 01:17:55 -0500
Message-ID: <4B19FAD5.5020802@zytor.com>
Date: Fri, 04 Dec 2009 22:16:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH] x86: Put trampoline_data into readonly section.
References: <b9df5fa10912040824r4c496b54x6165523935293001@mail.gmail.com>	 <4B19B53B.60605@zytor.com> <b9df5fa10912042047i7b6b84e2n2d2a5441d721b3ca@mail.gmail.com>
In-Reply-To: <b9df5fa10912042047i7b6b84e2n2d2a5441d721b3ca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 08:47 PM, Rakib Mullick wrote:
> On 12/5/09, H. Peter Anvin<hpa@zytor.com>  wrote:
>> On 12/04/2009 08:24 AM, Rakib Mullick wrote:
>>
>>   Perhaps the better thing would be to define trampoline_size as an
>>   absolute symbol in arch/x86/kernel/trampoline_*.S, especially since it
>>   probably generates bad code to subtract two global symbols like that.
>>
> But - trampoline_data is placed into - cpu init readonly data section.
> And we are
> referencing it from non-cpuinit function. ....... so I think the
> problem remains.
> Isn't it ? Or am I missing anything?
>

No, we're not actually referencing it at all.  We're just using its 
length, whereas in reality we actually have copied the code elsewhere 
already.

	-hpa
