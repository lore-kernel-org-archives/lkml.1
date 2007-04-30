Return-Path: <linux-kernel-owner+w=401wt.eu-S1946393AbXD3Qkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946393AbXD3Qkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946428AbXD3Qkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:40:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34170 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946393AbXD3Qk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:40:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 07/12] i386: Add missing !X86_PAE dependincy to the 2G/2G split.
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
	<m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com> <46361643.509@zytor.com>
Date: Mon, 30 Apr 2007 10:39:58 -0600
In-Reply-To: <46361643.509@zytor.com> (H. Peter Anvin's message of "Mon, 30
	Apr 2007 09:16:03 -0700")
Message-ID: <m1slah3jfl.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> When in PAE mode we require that the user kernel divide to be
>> on a 1G boundary.  The 2G/2G split does not have that property
>> so require !X86_PAE
>
> ?????
>
> 	-hpa

>From arch/i386/Kconfig:
> 
> choice
>         depends on EXPERIMENTAL
>         prompt "Memory split" if EMBEDDED
>         default VMSPLIT_3G
>         help
>           Select the desired split between kernel and user memory.
> 
>           If the address range available to the kernel is less than the
>           physical memory installed, the remaining memory will be available
>           as "high memory". Accessing high memory is a little more costly
>           than low memory, as it needs to be mapped into the kernel first.
>           Note that increasing the kernel address space limits the range
>           available to user programs, making the address space there
>           tighter.  Selecting anything other than the default 3G/1G split
>           will also likely make your kernel incompatible with binary-only
>           kernel modules.
> 
>           If you are not absolutely sure what you are doing, leave this
>           option alone!
> 
>         config VMSPLIT_3G
>                 bool "3G/1G user/kernel split"
>         config VMSPLIT_3G_OPT
>                 depends on !HIGHMEM
>                 bool "3G/1G user/kernel split (for full 1G low memory)"
>         config VMSPLIT_2G
>                 depends on !X86_PAE
>                 bool "2G/2G user/kernel split"
>         config VMSPLIT_1G
>                 bool "1G/3G user/kernel split"
> endchoice
> 
> config PAGE_OFFSET
>         hex
>         default 0xB0000000 if VMSPLIT_3G_OPT
>         default 0x78000000 if VMSPLIT_2G
>         default 0x40000000 if VMSPLIT_1G
>         default 0xC0000000

The default PAGE_OFFSET is at 0x7800000 for the 2G/2G split.
All of these options were originally !X86_PAE, I assume
the intention was to be able to have 2G of RAM without
needing high memory.

I don't really care I just saw the problem and decided to prevent
people trying a combination that simply doesn't work.

Eric
