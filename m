Return-Path: <linux-kernel-owner+w=401wt.eu-S1765167AbYEHVhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765167AbYEHVhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYEHVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:37:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:12370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbYEHVhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:37:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,456,1204531200"; 
   d="scan'208";a="326076270"
Date: Thu, 8 May 2008 14:37:22 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Message-ID: <20080508213722.GA28372@linux-os.sc.intel.com>
References: <4820962B.6050702@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com> <4820D415.5090900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com> <482217F3.2040900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com> <20080508192555.GA8643@linux-os.sc.intel.com> <48235DA1.5060809@numericable.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48235DA1.5060809@numericable.fr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 01:08:01PM -0700, Rufus & Azrael wrote:
>    Venki Pallipadi a ecrit :
>    >
>    > Use UC_MINUS in reserve_memtype call with -1, when MTRR lookup fails for
>    any
>    > reason.
>    >
>    > Change the logic in mtrr_type_lookup to just get the type from the start
>    > address. Using start and end adddress is not right/complete as start and
>    > end can be covered by different mtrr (where old code will fail) or
>    > start and end can be in same mtrr, but still have some different
>    > memory type region in between. Using only start is less restrictive and
>    > deterministic.
>    >
>    > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>    >
>    > ---
>    >  arch/x86/kernel/cpu/mtrr/generic.c |    7 ++-----
>    >  arch/x86/mm/pat.c                  |    8 +-------
>    >  2 files changed, 3 insertions(+), 12 deletions(-)
>    >
>
>    Hi Venki,
> 
>    Patch applied on 2.6.26-rc1-git5 and all works fine in X server with 
>    CONFIG_X86_PAT=y.
> 
>    See dmesg and mtrr files attached.
> 

Thanks for reporting the problem and testing the fix.
ingo/thomas/hpa: Can you please pick up this patch. Fixes the PAT regression
reported on this thread.

Thanks,
Venki

