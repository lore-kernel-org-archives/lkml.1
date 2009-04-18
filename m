Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZDRXdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZDRXdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 19:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZDRXcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 19:32:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:43390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZDRXcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 19:32:51 -0400
Message-ID: <49EA629C.1020307@kernel.org>
Date: Sat, 18 Apr 2009 16:30:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
References: <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <49EA5BB2.90603@kernel.org> <alpine.LFD.2.00.0904181605290.2199@localhost.localdomain> <49EA6197.2020800@kernel.org>
In-Reply-To: <49EA6197.2020800@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Linus Torvalds wrote:
>> On Sat, 18 Apr 2009, Yinghai Lu wrote:
>>> without your patch got
>>>
>>> 00000100-000973ff : System RAM
>>> 00097400-0009ffff : reserved
>>> 000a0000-000bffff : PCI Bus #00
>>> 000c0000-000cffff : pnp 00:0c
>>> 000e0000-000fffff : pnp 00:0c
>>> 00100000-b7f9ffff : System RAM
>>>   00200000-00c68f6b : Kernel code
>>>   00c68f6c-01332f7f : Kernel data
>>>   015a6000-01fcaa57 : Kernel bss
>>>   20000000-23ffffff : GART
>>> b7fa0000-b7fadfff : RAM buffer
>>> b7fae000-b7faffff : System RAM
>>> b7fb0000-b7fbdfff : ACPI Tables
>>> b7fbe000-b7feffff : ACPI Non-volatile Storage
>>> b7ff0000-b7ffffff : reserved
>>>   b7ff0000-b7ffffff : RAM buffer
>>> b8000000-beffffff : PCI Bus #00
>>> bf000000-bfffffff : PCI Bus #80
>> Yeah, that "RAM buffer" inside the b7ff0000-b7ffffff reserved area is 
>> obviously crap.
> 
> reserved from 0xb7ff0000 - 0xffffffff ranges are registered via e820_reserve_resources_late
> didn't have IORESOURCE_BUSY
> 
> but RAM buffer area has that IORESOURCE_BUSY
> 
aka those "reserved" is not really reserved.

YH
