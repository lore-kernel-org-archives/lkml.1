Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbXJWC0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbXJWC0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXJWC0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:26:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:39941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbXJWCZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,314,1188802800"; 
   d="scan'208";a="182895742"
Subject: Re: [PATCH -v6 0/3] x86 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <471CEEFA.60001@zytor.com>
References: <1193037408.23935.21.camel@caritas-dev.intel.com>
	 <471CEEFA.60001@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Oct 2007 10:28:35 +0800
Message-Id: <1193106515.23935.60.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 23 Oct 2007 02:25:54.0244 (UTC) FILETIME=[097BE040:01C8151C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

On Mon, 2007-10-22 at 11:42 -0700, H. Peter Anvin wrote:
> This patchset should be rebased on top of Rusty's changes; the rebase is 
>   fairly trivial and I was originally intending to simply commit the 
> rebase as-is, with the boot protocol version bumped to 2.08.
> 
> However, the documentation section is simply wrong in a number of 
> places.  In particular:
> 
> +In 32-bit boot protocol, the first step in loading a Linux kernel
> +should still be to load the real-mode code and then examine the kernel
> +header at offset 0x01f1. But, it is not necessary to load all
> +real-mode code, just first 4K bytes traditionally known as "zero page"
> +is needed.
> 
> This is incorrect.  The zeropage (which really is better referred to as 
> struct boot_param) should be initialized to all zero, except for the 
> setup header (starting at offset 0x1f0 or 0x1f1(*)) to the length 
> specified either by boot protocol version or by the byte at offset 0x201.

I will change this.

> +At entry, the CPU must be in 32-bit protected mode with paging
> +disabled; the CS and DS must be 4G flat segments; %esi holds the base
> +address of the "zero page"; %esp, %ebp, %edi should be zero.
> 
> You also need to have a GDT loaded with the selectors for __BOOT_CS 
> (0x10) and __BOOT_DS (0x18) containing appropriate values, and you 
> should enter with interrupts disabled.  For safety, set up ES and SS as 
> well as DS.
> 
> The bit about %esp, %ebp and %edi being zero is nonsense, although 
> specifying at least %ebp == %edi == 0 for future use isn't a bad idea. 
> On the other hand, %ebx *is* supposed to be zero.

I will change this.

> The documentation in zero-page.txt is wrong when it comes to protocol 
> versions.  Most of these fields are ancient, and only a handful of the 
> remainder can be tied to specific protocol versions.

So, should the protocol of current fields be set to "ALL" as that of
setup header.

> +  struct setup_data {
> +	  u64 next;
> +	  u32 type;
> +	  u32 len;
> +	  u8  data[0];
> +  } __attribute__((packed));
> 
> Why packed?

I will change this.

> Time permitting, I might rewrite this myself, but it may be quicker for 
> you to update it.

OK, I will update it as soon as possible.

Best Regards,
Huang Ying
