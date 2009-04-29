Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZD2Ljj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZD2Ljj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbZD2Lj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:39:29 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33568 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZD2Lj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:39:29 -0400
Message-ID: <49F83C6D.3090509@monstr.eu>
Date: Wed, 29 Apr 2009 13:39:25 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 22/30] microblaze_mmu_v1: Update linker script for MMU
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <1240821139-7247-22-git-send-email-monstr@monstr.eu> <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904291327.50092.arnd@arndb.de>
In-Reply-To: <200904291327.50092.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 27 April 2009, monstr@monstr.eu wrote:
>> --- a/arch/microblaze/kernel/vmlinux.lds.S
>> +++ b/arch/microblaze/kernel/vmlinux.lds.S
>> @@ -17,8 +17,11 @@ ENTRY(_start)
>>  jiffies = jiffies_64 + 4;
>>  
>>  SECTIONS {
>> +#ifdef CONFIG_MMU
>> +       . = CONFIG_KERNEL_START;
>> +#else
>>         . = CONFIG_KERNEL_BASE_ADDR;
>> -
>> +#endif
>>         .text : {
>>                 _text = . ;
>>                 _stext = . ;
> 
> This change looks a bit bogus, can't you use the same symbol for
> both? I guess either one would be fine, but I don't see a reason
> for them to be different.

It will be possible to set for noMMU kernel
CONFIG_KERNEL_BASE_ADDR is CONFIG_KERNEL_START which can remove it.

CONFIG_KERNEL_START is physical base memory address because of noMMU
KERNEL_BASE_ADDR is 0xC0000000 buf of course could be change in menuconfig.

I'll do some tests.

Thanks,
Michal



> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
