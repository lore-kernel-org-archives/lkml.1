Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZDRXKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZDRXKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 19:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZDRXKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 19:10:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbZDRXKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 19:10:40 -0400
Date: Sat, 18 Apr 2009 16:04:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
In-Reply-To: <49EA57C4.1000603@kernel.org>
Message-ID: <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain>
References: <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes>
 <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
 <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Apr 2009, Yinghai Lu wrote:
> 
> with
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000100 - 0000000000097400 (usable)
> [    0.000000]  BIOS-e820: 0000000000097400 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000b7fa0000 (usable)
> [    0.000000]  BIOS-e820: 00000000b7fae000 - 00000000b7fb0000 (usable)
> [    0.000000]  BIOS-e820: 00000000b7fb0000 - 00000000b7fbe000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000b7fbe000 - 00000000b7ff0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000b7ff0000 - 00000000b8000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000002048000000 (usable)
> 
> got
> 
> 00000100-000973ff : System RAM
> 00097400-0009ffff : reserved
> 000a0000-000bffff : PCI Bus #00
> 000c0000-000cffff : pnp 00:0c
> 000e0000-000fffff : pnp 00:0c
> 00100000-b7f9ffff : System RAM
>   00200000-00c68f6b : Kernel code
>   00c68f6c-01332f7f : Kernel data
>   015a6000-01fcaa57 : Kernel bss
>   20000000-23ffffff : GART
> b7fa0000-b7fadfff : RAM buffer
> b7fae000-b7faffff : System RAM
> b7fb0000-b7fbdfff : ACPI Tables
> b7fbe000-b7feffff : ACPI Non-volatile Storage
> b7ff0000-b7ffffff : reserved

Hmm. That looks correct to me. We filled in that odd area between 
b7fa0000-b7fadfff that went unmentioned in the e820 tables.

And that _is_ a really odd hole. I wonder what it is all about. But the 
approach does seem to have done the right thing.

			Linus
