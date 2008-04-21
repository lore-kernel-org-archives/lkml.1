Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbYDUIW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbYDUIW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYDUIWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:22:51 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:44877 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbYDUIWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:22:50 -0400
Message-ID: <480C4EAB.9090004@firmworks.com>
Date: Sun, 20 Apr 2008 22:22:03 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andres Salomon <dilinger@queued.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	 <20080418202925.b18452c5.akpm@linux-foundation.org>	 <20080419092544.378664a8@ephemeral>	 <20080419133909.5aa6b63e@ephemeral>	 <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>	 <480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral>	 <480B8E9F.8000701@firmworks.com> <480B95B4.5030203@zytor.com>	 <480C0C5B.2050403@firmworks.com> <86802c440804202154t184671d5t33b44fffc4d88cd5@mail.gmail.com>
In-Reply-To: <86802c440804202154t184671d5t33b44fffc4d88cd5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
>
>> path" for kernel builds.
>>
>>  b) OFW loads the bzimage kernel at 0x100000 and the ramdisk image, if any,
>> at 0x800000.
>>     
>
> so you are assuming that your uncompressed vmlinux only use less 8M space?
>
> you are supposed to check the bzImage to get uncompressed vmlinux size.
>   

The 0x800000 ramdisk load address is an OLPC-specific firmware 
implementation detail that could easily be changed without affecting 
anything else. I probably shouldn't have mentioned it because it isn't 
really an integral part of the interface "contract".

I certainly hope that the OLPC kernel never gets anywhere near that 
size.  The OLPC hardware has limited configurability, so it's not 
plausible that the kernel would grow that large to include a huge kit of 
drivers.  If the kernel file becomes large as a result of including the 
initramfs in the same file, the 0x800000 ramdisk load address won't 
apply (because there won't be a separate load of the initramfs file), so 
the kernel could be extend way past that boundary with no problems.

If we get to the point where we do need huge kernels on OLPC, we can 
release a firmware upgrade along with the new OS.  We have mechanisms 
for coordinating firmware and OS upgrades.

If a new customer for OFW on x86 appears, I'll remember to float the 
boundary above the bzImage uncompressed size (assuming that the bzimage 
format is still applicable when that happens).
> YH
>
>   
