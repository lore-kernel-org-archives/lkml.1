Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbXEARRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbXEARRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXEARRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:17:48 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55092 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbXEARRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:17:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the 2G/2G split.
References: <20070501557.815359000@suse.de>
	<20070501035829.1C93D13CAF@wotan.suse.de> <4636C16F.204@cosmosbay.com>
	<20070501062132.GQ25929@bingen.suse.de>
	<20070501130132.GL26598@holomorphy.com>
	<46376210.6090200@cosmosbay.com>
	<20070501170046.GO26598@holomorphy.com>
Date: Tue, 01 May 2007 11:17:28 -0600
In-Reply-To: <20070501170046.GO26598@holomorphy.com> (Bill Irwin's message of
	"Tue, 1 May 2007 10:00:46 -0700")
Message-ID: <m1d51kzcnr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin <bill.irwin@oracle.com> writes:

>
> Only 1GB-aligned kernel/user splits are now handled for PAE. The
> 2GB/2GB split attempts to avoid aliasing vmallocspace with the 1:1
> mapping for physical memory by using an actual split of 1.875/2.125
> to accommodate 128MB of vmallocspace out of what would otherwise
> be a full 2GB for userspace. That attempt disturbs the alignment
> required by PAE for 2GB/2GB splits, and furthermore does not provide
> a 2GB/2GB split as advertised.
>
> This patch resolves the issues here in two manners. The first is
> by providing a true 2GB/2GB split in addition to the 1.875/2.125
> split. The second is by renaming the 1.875/2.125 split to
> CONFIG_VMSPLIT_2G_OPT analogously to CONFIG_VMSPLIT_3G_OPT, which
> performs a similar manuever to avoid aliasing vmallocspace with
> the 1:1 mapping for physical memory around the 3GB boundary. With
> the 1.875/2.125 split properly-named, its config option is then
> tagged as depending on !HIGHMEM to express the PAE implementation's
> current inability to deal with such unaligned splits.
>
> This patch is essentially a combination of two patches, one written
> by Eric Biederman and the other by Eric Dumazet. If they could add
> their Signed-off-by: to this, I'd be much obliged.
>
> Signed-off-by: William Irwin <wli@holomorphy.com>
> Cc: Eric Dumazet <dada1@cosmosbay.com>
> Cc: Mark Lord <lkml@rtr.ca>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Andi Kleen <ak@suse.de>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
>
> Index: sched/arch/i386/Kconfig
> ===================================================================
> --- sched.orig/arch/i386/Kconfig	2007-05-01 04:35:47.065162310 -0700
> +++ sched/arch/i386/Kconfig	2007-05-01 04:36:50.100754504 -0700
> @@ -571,6 +571,9 @@
>  		bool "3G/1G user/kernel split (for full 1G low memory)"
>  	config VMSPLIT_2G
>  		bool "2G/2G user/kernel split"
> +	config VMSPLIT_2G_OPT
> +		depends on !HIGHMEM
> +		bool "2G/2G user/kernel split (for full 2G low memory)"
>  	config VMSPLIT_1G
>  		bool "1G/3G user/kernel split"
>  endchoice
> @@ -578,7 +581,8 @@
>  config PAGE_OFFSET
>  	hex
>  	default 0xB0000000 if VMSPLIT_3G_OPT
> -	default 0x78000000 if VMSPLIT_2G
> +	default 0x80000000 if VMSPLIT_2G
> +	default 0x78000000 if VMSPLIT_2G_OPT
>  	default 0x40000000 if VMSPLIT_1G
>  	default 0xC0000000
>  
