Return-Path: <linux-kernel-owner+w=401wt.eu-S934138AbYEHWRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138AbYEHWRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762494AbYEHWRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:17:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:34951 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760040AbYEHWRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:17:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,456,1204531200"; 
   d="scan'208";a="381601963"
Date: Thu, 8 May 2008 15:16:59 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh B Siddha <suresh.b.siddha@intel.com>, arjan@infradead.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Remove 6 bank limitation in 64 bit MCE reporting code
Message-ID: <20080508221659.GA2759@linux-os.sc.intel.com>
References: <20080508211836.GA26353@linux-os.sc.intel.com> <4823705E.1040401@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4823705E.1040401@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 02:27:58PM -0700, H. Peter Anvin wrote:
> Venki Pallipadi wrote:
> >Eliminate the 6 bank restriction in 64 bit mce reporting code. This 
> >restriction
> >is artificial (due to static creation of sysfs files) and 32 bit code
> >does not have any such restriction.
> >
> >This change helps in reporting the details of machine checks on a machine 
> >check
> >exception with errors in bank 6 and above on CPUs that support those banks.
> >Without the patch, machine check errors in those banks are not reported.
> >
> >We still have 128 (MCE_EXTENDED_BANK) bank restriction instead of max 256
> >supported in hardware. That is not changed in the patch below as it will 
> >have
> >some user level mcelog utility dependency, with bank 128 being used for
> >thermal reporting currently.
> >
> >The patch below does not create sysfs control (bankNctl) for banks higher
> >than 6 as well. That needs some pre-cleanup in /sysfs mce layout, removal 
> >of
> >per cpu /sysfs entries for bankctl as they are really global system level
> >control today. That change will follow. This basic change is critical to
> >report the detailed errors on banks higher than 6.
> >
> >Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> Any chance you could add unifying the 32 and 64-bit code to your list, 
> since you're already working on eliminating differences there?
> 

It was tried earlier
http://www.ussg.iu.edu/hypermail/linux/kernel/0505.2/0982.html
but never made it.

Yes. Will add that to the todo list.

Thanks,
Venki
