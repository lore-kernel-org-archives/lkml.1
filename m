Return-Path: <linux-kernel-owner+w=401wt.eu-S934834AbYEIAx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934834AbYEIAx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934243AbYEIAxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:53:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763467AbYEIAxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:53:07 -0400
Message-ID: <4823A059.1090400@zytor.com>
Date: Thu, 08 May 2008 17:52:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Rufus & Azrael <rufus-azrael@numericable.fr>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem
 error
References: <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com> <20080508192555.GA8643@linux-os.sc.intel.com> <48235DA1.5060809@numericable.fr> <20080508213722.GA28372@linux-os.sc.intel.com> <482373C5.1060202@zytor.com> <20080508215931.GA5035@jamoon.sc.intel.com> <20080508234016.GA14169@linux-os.sc.intel.com> <482392C4.7080901@zytor.com> <20080509003424.GA19710@linux-os.sc.intel.com>
In-Reply-To: <20080509003424.GA19710@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> 
> One of the reason for heristic was to get proper type for /dev/mem maps for WB
> region (ACPI and BIOS area). /dev/mem checks to see the mtrr type of the start
> address and starts with that type for the request. As long as there are no
> other conflict in PAT list, we can give WB to this /dev/mem request. Not
> having this heuristic we will have to most probably default to UC.
> 
> When there are overlapping PAT list entries, the mtrr_lookup does not matter
> as we have to inherit things from those PAT entries or conflicting with them.
> 

Okay, now here is something...

I don't believe it is kosher for mmap() to behave differently if we 
called it once or called it twice.

Therefore, the proper behaviour in the case of a range that covers 
multiple types is to break it down into multiple requests each mapped 
with the appropriate type, as if mmap had been called separate on each 
subrange.  In the limiting case, yes, this does mean the subranges can 
be individual pages, but such an outcome is vanishingly improbable in 
practice.

	-hpa

