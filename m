Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0BBKQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 05:16:52 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:41488 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab0BBKQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 05:16:50 -0500
Message-ID: <4B67FB13.9000005@petalogix.com>
Date: Tue, 02 Feb 2010 11:14:43 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions - 221af7f87b97431e3ee21ce4b0e77d5411cf1549
References: <4B66DE64.8010101@petalogix.com> <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain> <4B672C31.9070302@zytor.com>
In-Reply-To: <4B672C31.9070302@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 02/01/2010 07:57 AM, Linus Torvalds wrote:
>> That said, Microblaze is not one of the architectures I would have 
>> expected to have problems. It has one of the most straightforward 
>> "flush_thread()" implementations in the whole kernel (it's a no-op ;), and 
>> that's where most of the hacky things were for the architectures that 
>> needed the change. And it has no "arch_pick_mmap_layout()" issues or 
>> anything else that tends to depend on personality bits or whatever.
>>
>> Microblaze is a no-MMU platform, isn't it? Which binary format does it 
>> use? It looks like _some_ binaries work (it seems to happily be running a 
>> shell to actually do those startup scripts) while others have problems. Is 
>> there a difference between "/bin/sh" and the binaries that seem to be 
>> problematic (like /bin/mount and /bin/ifup).
>>
>> Are the failing binaries all setuid ones, for example? Or shared vs 
>> non-shared? Or ELF vs FLAT or whatever?
>>
> 
> Another thing... it looks like you [Michal] is running a test image
> under Qemu... could you perhaps point us to that image or another test
> image which reproduces the problem?

Yes, you are right. I am doing every day testing on qemu.
I have prepared package which contain all things which you need.
Please download it from http://www.monstr.eu/20100202-flush.tar.gz
md5sum cfe59b19e52dff2319a2b1919839d5cd  20100202-flush.tar.gz

I added there README where you will find more information. Also there is 
rootfs.cpio which you can use. Compile kernel with this patch and try. 
Then you can revert it and retest - you should be able to see that behavior.

If you have any problem with it, please let me know.

Michal

P.S.: you don't need to care about FPU error in bootlog - fpu is not used.

> 
> Nothing like having a hands-on testcase...
> 
> 	-hpa
> 


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
