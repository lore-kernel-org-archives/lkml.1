Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbYAHIU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbYAHIU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYAHIUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:20:15 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:36458 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750902AbYAHIUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:20:13 -0500
Message-ID: <47833231.3080801@linux.vnet.ibm.com>
Date: Tue, 08 Jan 2008 13:50:01 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, bunk@kernel.org,
       clameter@sgi.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7 Build-Failure at __you_cannot_kmalloc_that_much
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <478200A4.4090707@linux.vnet.ibm.com> <20080107100733.3655f74f.akpm@linux-foundation.org>
In-Reply-To: <20080107100733.3655f74f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 07 Jan 2008 16:06:20 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> The defconfig make fails on x86_64 (AMD box) with following error
>>
>>   CHK     include/linux/utsrelease.h
>>   CALL    scripts/checksyscalls.sh
>>   CHK     include/linux/compile.h
>>   GEN     .version
>>   CHK     include/linux/compile.h
>>   UPD     include/linux/compile.h
>>   CC      init/version.o
>>   LD      init/built-in.o
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o(.init.text+0x8d76): In function `dmi_id_init':
>> : undefined reference to `__you_cannot_kmalloc_that_much'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>>
>> # gcc --version
>> gcc (GCC) 3.2.3 20030502 (Red Hat Linux 3.2.3-59)
>>
>> This was reported by Adrian Bunk http://lkml.org/lkml/2007/12/1/39
> 
> That's odd.  afacit the only kmalloc in dmi_id_init() is
> 
>         dmi_dev = kzalloc(sizeof(*dmi_dev), GFP_KERNEL);
> 
> and even gcc-3.2.3 should be able to get that right.
> 
> Could you please a) verify that simply removing that line fixes the build
> error and then b) try to find some way of fixing it?
> 
> Try replacing `sizeof(*dmi_dev)' with `sizeof(struct dmi_device_attribute)'
> and any other tricks you can think of to try to make the compiler process
> the code differently.
> 

removing the line fixes the issue, but changing the sizeof(*dmi_dev) to
sizeof(struct device) is not helping.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
