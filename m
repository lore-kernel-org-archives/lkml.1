Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbZLRNnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbZLRNnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZLRNns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:43:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZLRNnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:43:47 -0500
Message-ID: <4B2B86CE.4020304@suse.de>
Date: Fri, 18 Dec 2009 14:42:38 +0100
From: Thomas Renninger <trenn@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, "lenb@kernel.org" <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATH 1/5 -v2] acpi, IO memory pre-mapping and atomic accessing
References: <1260429413.15264.393.camel@yhuang-dev.sh.intel.com>	 <200912111036.15063.bjorn.helgaas@hp.com>	 <1260839053.12561.1098.camel@yhuang-dev.sh.intel.com>	 <200912151047.14196.bjorn.helgaas@hp.com> <1260926595.12561.1188.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1260926595.12561.1188.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 02:23 AM, Huang Ying wrote:
> On Wed, 2009-12-16 at 01:47 +0800, Bjorn Helgaas wrote: 
>> On Monday 14 December 2009 06:04:13 pm Huang Ying wrote:
...
>>> The checking here is for bug in firmware not software. I think it is
>>> necessary for the user to know where the bugs may come from, and it is
>>> hard to express the bug in return code.
>>
>> Yes, I understand that this is checking for firmware bugs.  My point
>> is that when a user sees this in his dmesg log:
>>
>> 	Invalid bit width in GAR, firmware bug?
>>
>> we have no context, and even a kernel developer can't figure out what
>> to do.  We could ask for a copy of the FADT and DSDT, but even then,
>> we don't know *which* GAR structure to look at, so we'll probably have
>> to add some instrumentation and ask the user to reproduce the problem.
>>
>> If the check were in the caller, it could at least say something like:
>>
>> 	ACPI: couldn't map generic address [io 0xcf8] for PCI config access
>>
>> which would give us more useful information.
> 
> En... Yes, some information about the invalid GAR is helpful. But the
> GAR information is available in acpi_check_gar too, so we can output
> something as follow in acpi_check_gar:
> 
>     Invalid bit width in GAR [mem 0x8029ff8 24], firmware bug?
> 
> Your message looks like a software issue instead of firmware bug. This
> may confuse the user and developer.

Please use one of these (cmp. with include/linux/kernel.h when to use
which):
#define FW_BUG          "[Firmware Bug]: "
#define FW_WARN         "[Firmware Warn]: "
#define FW_INFO         "[Firmware Info]: "

It's great that someone cares to tell syslog/users that it's a firmware
bug, that should get more common...

      Thomas
