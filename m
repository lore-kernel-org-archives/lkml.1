Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZKLT1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZKLT1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZKLT1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:27:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:46201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZKLT1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:27:23 -0500
Message-ID: <4AFC613D.2060808@kernel.org>
Date: Thu, 12 Nov 2009 11:25:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
References: <4AF7D820.5040503@kernel.org> <200911091315.13151.rjw@sisk.pl> <4AFA210B.3020207@kernel.org> <20091112073616.GA11365@elf.ucw.cz>
In-Reply-To: <20091112073616.GA11365@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2009-11-10 18:27:23, Yinghai Lu wrote:
>> try to find_e820_area/reserve_early, and call acpi_reserve_memory early
>>
>> to get area is below 1M
> 
>> -	acpi_realmode = (unsigned long)alloc_bootmem_low(WAKEUP_SIZE);
>> +	mem = find_e820_area(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
>>  
>> -	if (!acpi_realmode) {
>> +	if (mem == -1L) {
>>  		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
>>  		return;
>>  	}
> 
> How is it better then old code?

could get range below 1M.

alloc_bootmem_low can not make sure get that below 1M.

init_memory_mapping could use below 1M as page table...

so need to get some buffer for acpi wakeup realmode code.

YH
