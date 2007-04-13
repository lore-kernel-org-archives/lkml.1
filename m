Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXDMVKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXDMVKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030320AbXDMVKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:10:16 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:35659 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030316AbXDMVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:10:07 -0400
Message-ID: <461FF101.1080502@vmware.com>
Date: Fri, 13 Apr 2007 14:07:13 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash while mapping memory in pagetable_init() (Was: Re: .config)
References: <20070413174913.GA25234@ezr.goop.org> <20070413183841.GP10574@sequoia.sous-sol.org> <20070413190552.GQ10574@sequoia.sous-sol.org> <461FD97B.1010203@goop.org> <461FE36D.1050205@vmware.com> <461FE77A.6020307@zytor.com> <461FE7C7.7050204@goop.org> <461FE8EC.3090304@zytor.com> <461FEA0B.40700@zytor.com>
In-Reply-To: <461FEA0B.40700@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>
> #ifdef CONFIG_X86_PAE
> PAGE_TABLE_SIZE = (2048+4)*4096
> #else
> PAGE_TABLE_SIZE = (1024+1)*4096
> #endif
> BOOTMEM_SIZE = 128*1024

/* ACPI and SMP trampoline allocate bootmem pages before paging_init */
#ifdef CONFIG_SMP
SMP_BOOTMEM_EARLY= 1
#else
SMP_BOOTMEM_EARLY= 0
#endif

#ifdef CONFIG_ACPI
ACPI_BOOTMEM_EARLY = 1
#else
ACPI_BOOTMEM_EARLY = 0
#endif

>
> INIT_MAP_BEYOND_END = BOOTMEM_SIZE + PAGE_TABLE_SIZE

+SMP_BOOTMEM_EARLY + ACPI_BOOTMEM_EARLY

Zach
