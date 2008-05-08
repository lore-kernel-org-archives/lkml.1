Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbYEHVcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbYEHVcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYEHVcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:32:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38752 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYEHVb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:31:58 -0400
Message-ID: <4823705E.1040401@zytor.com>
Date: Thu, 08 May 2008 14:27:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh B Siddha <suresh.b.siddha@intel.com>, arjan@infradead.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Remove 6 bank limitation in 64 bit MCE reporting
 code
References: <20080508211836.GA26353@linux-os.sc.intel.com>
In-Reply-To: <20080508211836.GA26353@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> Eliminate the 6 bank restriction in 64 bit mce reporting code. This restriction
> is artificial (due to static creation of sysfs files) and 32 bit code
> does not have any such restriction.
> 
> This change helps in reporting the details of machine checks on a machine check
> exception with errors in bank 6 and above on CPUs that support those banks.
> Without the patch, machine check errors in those banks are not reported.
> 
> We still have 128 (MCE_EXTENDED_BANK) bank restriction instead of max 256
> supported in hardware. That is not changed in the patch below as it will have
> some user level mcelog utility dependency, with bank 128 being used for
> thermal reporting currently.
> 
> The patch below does not create sysfs control (bankNctl) for banks higher
> than 6 as well. That needs some pre-cleanup in /sysfs mce layout, removal of
> per cpu /sysfs entries for bankctl as they are really global system level
> control today. That change will follow. This basic change is critical to
> report the detailed errors on banks higher than 6.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Any chance you could add unifying the 32 and 64-bit code to your list, 
since you're already working on eliminating differences there?

	-hpa
