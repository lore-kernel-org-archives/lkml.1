Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756905AbYLQDr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYLQDr2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYLQDrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:47:18 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:40418 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYLQDrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:47:17 -0500
Date: Wed, 17 Dec 2008 09:17:03 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
        mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint
	handler interfaces
Message-ID: <20081217034703.GA5084@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081204190804.GA15134@in.ibm.com> <20081204191119.GA20563@in.ibm.com> <493831A9.3050904@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493831A9.3050904@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 11:38:17AM -0800, David Daney wrote:
> K.Prasad wrote:
> [...]
>> + * len and type values are defined in include/asm/hw_breakpoint.h.
>> + * Available values vary according to the architecture.  On i386 the
>> + * possibilities are:
>> + *
>> + *	HW_BREAKPOINT_LEN_1
>> + *	HW_BREAKPOINT_LEN_2
>> + *	HW_BREAKPOINT_LEN_4
>> + *	HW_BREAKPOINT_LEN_EXECUTE
>> + *	HW_BREAKPOINT_RW
>> + *	HW_BREAKPOINT_READ
>> + *	HW_BREAKPOINT_EXECUTE
>> + *
>> + * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
>> + * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
>> + * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
>> + */
>
> On MIPS we support breakpoint lengths that are powers of 2 between 8 and  
> 4096.  Do you really want symbolic values for these?  The debuggers have  
> to do calculations with the length values, so translating between the  
> symbolic values and numeric values would be tedious at best.
>
>
> David Daney

Given that the possible values for length are finite and small on
x86(just three of them), it was chosen to be defined as constants.

For architectures such as MIPS where a range of lengths can be possibly
monitored using HW Breakpoints, the arch_validate_hwbkpt_settings()
maybe suitably written to validate the input and the 'length' may also
be specified in numeric terms to the kernel interface (say
register_kernel_hw_breakpoint()).

Thanks,
K.Prasad

