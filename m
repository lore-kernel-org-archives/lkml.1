Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbZD2KRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbZD2KRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZD2KQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:16:54 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59630 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZD2KQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:16:53 -0400
Message-ID: <49F82911.6060207@monstr.eu>
Date: Wed, 29 Apr 2009 12:16:49 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 23/30] microblaze_mmu_v1: Enable fork syscall for MMU
 and add fork as vfork for noMMU
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>	 <1240821139-7247-16-git-send-email-monstr@monstr.eu>	 <1240821139-7247-17-git-send-email-monstr@monstr.eu>	 <1240821139-7247-18-git-send-email-monstr@monstr.eu>	 <1240821139-7247-19-git-send-email-monstr@monstr.eu>	 <1240821139-7247-20-git-send-email-monstr@monstr.eu>	 <1240821139-7247-21-git-send-email-monstr@monstr.eu>	 <1240821139-7247-22-git-send-email-monstr@monstr.eu>	 <1240821139-7247-23-git-send-email-monstr@monstr.eu>	 <1240821139-7247-24-git-send-email-monstr@monstr.eu> <1d3f23370904270443u4ef547b3hab25b65babe329f3@mail.gmail.com>
In-Reply-To: <1d3f23370904270443u4ef547b3hab25b65babe329f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Williams wrote:
> On Mon, Apr 27, 2009 at 6:32 PM,  <monstr@monstr.eu> wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  arch/microblaze/kernel/entry-nommu.S   |    3 ++-
>>  arch/microblaze/kernel/syscall_table.S |    2 +-
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
>> index f24b126..89f978a 100644
>> --- a/arch/microblaze/kernel/entry-nommu.S
>> +++ b/arch/microblaze/kernel/entry-nommu.S
>> @@ -10,7 +10,7 @@
>>
>>  #include <linux/linkage.h>
>>  #include <asm/thread_info.h>
>> -#include <asm/errno.h>
>> +#include <linux/errno.h>
>>  #include <asm/entry.h>
>>  #include <asm/asm-offsets.h>
>>  #include <asm/registers.h>
>> @@ -551,6 +551,7 @@ no_work_pending:
>>        rtid    r14, 0
>>        nop
>>
>> +sys_fork_wrapper:
>>  sys_vfork_wrapper:
>>        brid    sys_vfork
>>        addk    r5, r1, r0
> 
> NACK!  If only it was that easy :)
> 
> On noMMU we cannot just silently call vfork() if the application tries
> to fork() - you have to return -ENOSYS (or is there a better one?).
> This will just require a small sys_fork_wrapper in entry-nommu.S.

I will call for noMMU kernel ni_syscall which solve that problem.
(Arnd do it in his patches too)

Thanks,
Michal

> 
> John


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
