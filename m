Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbZHLPNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbZHLPNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZHLPNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:13:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZHLPNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:13:44 -0400
Message-ID: <4A82DBA2.2000509@zytor.com>
Date: Wed, 12 Aug 2009 08:11:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Joseph Cihula <joseph.cihula@intel.com>, Shane Wang <shane.wang@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       andi@firstfloor.org, chrisw@sous-sol.org, jmorris@namei.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com
Subject: Re: [RFC v6][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution	Technology
 support for Linux - Details
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu>
In-Reply-To: <20090812145321.GA11347@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2009 07:53 AM, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> i reviewed & tried the latest patches. Structure of v6 looks now 
>> looks pretty good, but there are some build problems:
>>
>> arch/x86/kernel/tboot.c: In function ‘tboot_probe’:
>> arch/x86/kernel/tboot.c:76: error: implicit declaration of function ‘set_fixmap’
>> arch/x86/kernel/tboot.c:76: error: ‘FIX_TBOOT_BASE’ undeclared (first use in this function)
>> arch/x86/kernel/tboot.c:76: error: (Each undeclared identifier is reported only once
>> arch/x86/kernel/tboot.c:76: error: for each function it appears in.)
>> arch/x86/kernel/tboot.c:77: error: implicit declaration of function ‘fix_to_virt’
>> arch/x86/kernel/tboot.c:77: warning: cast to pointer from integer of different size
>>
>> config attached.
> 
> ok, hpa fixed this bug - i tested it some more and here's the next 
> issue:
> 
> arch/x86/built-in.o: In function `tboot_shutdown':
> (.text+0x2e3b5): undefined reference to `acpi_wakeup_address'arch/x86/built-in.o: In function `tboot_sleep':
> (.text+0x2e679): undefined reference to `acpi_wakeup_address'
> 
> Config attached below.
> 

tboot_sleep() references acpi_wakeup_address, which is only defined if
CONFIG_ACPI_SLEEP is set.  We *could* make TBOOT require
CONFIG_ACPI_SLEEP, but that looks like the wrong thing to do to me,
unless TXT somehow depends on having S3 support.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

