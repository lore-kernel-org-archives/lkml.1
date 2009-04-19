Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZDSAef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZDSAef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 20:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZDSAe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 20:34:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbZDSAeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 20:34:25 -0400
Message-ID: <49EA7111.7040907@zytor.com>
Date: Sat, 18 Apr 2009 17:32:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
References: <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>>
>> 00000100-000973ff : System RAM
>> 00097400-0009ffff : reserved
>> 000a0000-000bffff : PCI Bus #00
>> 000c0000-000cffff : pnp 00:0c
>> 000e0000-000fffff : pnp 00:0c
>> 00100000-b7f9ffff : System RAM
>>   00200000-00c68f6b : Kernel code
>>   00c68f6c-01332f7f : Kernel data
>>   015a6000-01fcaa57 : Kernel bss
>>   20000000-23ffffff : GART
>> b7fa0000-b7fadfff : RAM buffer
>> b7fae000-b7faffff : System RAM
>> b7fb0000-b7fbdfff : ACPI Tables
>> b7fbe000-b7feffff : ACPI Non-volatile Storage
>> b7ff0000-b7ffffff : reserved
> 
> Hmm. That looks correct to me. We filled in that odd area between 
> b7fa0000-b7fadfff that went unmentioned in the e820 tables.
> 
> And that _is_ a really odd hole. I wonder what it is all about. But the 
> approach does seem to have done the right thing.
> 

Looks to me as through the BIOS rounded the end of available memory to a
64K boundary after subtracting the ACPI storage.  That might have been
done to work around an OS loader bug somewhere.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

