Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZEZFru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZEZFru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 01:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZEZFrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 01:47:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:32658 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZEZFrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 01:47:42 -0400
Message-ID: <4A1B827B.90302@monstr.eu>
Date: Tue, 26 May 2009 07:47:39 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org, John Williams <john.williams@petalogix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ipc64_perm - generic
References: <4A1AE972.9010905@monstr.eu> <200905252221.44082.arnd@arndb.de>
In-Reply-To: <200905252221.44082.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 25 May 2009 18:54:42 Michal Simek wrote:
>> Hi Arnd, cc: John
>>
>> From asm-generic/posix_types.h
>>
>> 17 #ifndef __kernel_mode_t
>> 18 typedef unsigned int    __kernel_mode_t;
>> 19 #endif
>>
>> This structure is not aligned properly because of pad2.
>>
>> 19 struct ipc64_perm {
>> 20         __kernel_key_t          key;
>> 21         __kernel_uid32_t        uid;
>> 22         __kernel_gid32_t        gid;
>> 23         __kernel_uid32_t        cuid;
>> 24         __kernel_gid32_t        cgid;
>> 25         __kernel_mode_t         mode;
>> 26         unsigned short          __pad1;
>> 27         unsigned short          seq;
>> 28         unsigned short          __pad2;
>> 29         unsigned long           __unused1;
>> 30         unsigned long           __unused2;
>> 31 };
>>
>> I think we should remove __pad1.
>> What do you think?
> 
> Right, well spotted.
> 
> I'd like to keep the struct ipc64_perm compatible with most architectures, so
> maybe we can play a little trick here:
> 
>> Here is proposed struct.
>>  struct ipc64_perm {
>>          __kernel_key_t          key;
>>          __kernel_uid32_t        uid;
>>          __kernel_gid32_t        gid;
>>          __kernel_uid32_t        cuid;
>>          __kernel_gid32_t        cgid;
>>          __kernel_mode_t         mode;
> 
> +	unsigned char __pad1[4 - sizeof(__kernel_mode_t)];
> 
>>          unsigned short          seq;
>>          unsigned short          __pad2;
>>          unsigned long           __unused1;
>>          unsigned long           __unused2;
>>  };
> 
> If that's too much of a hack, we could also change the default __kernel_mode_t
> in asm-generic/posix_types.h to unsigned short, which it is on all 32-bit architectures
> except mips and xtensa. For some reason, all 64 bit architechtures use unsigned
> int for mode_t, but I couldn't find out why. Glibc uses unsigned int externally.

Is it this final solution (that above) or we just change kernel_mode_t to short?

Michal





> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
