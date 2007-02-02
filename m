Return-Path: <linux-kernel-owner+w=401wt.eu-S1945948AbXBBPqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945948AbXBBPqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945945AbXBBPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:46:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:24465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945931AbXBBPqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:46:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,273,1167638400"; 
   d="scan'208"; a="42359772:sNHT22255011"
Message-ID: <45C35CC1.3090809@linux.intel.com>
Date: Fri, 02 Feb 2007 18:46:09 +0300
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Bob Picco <bob.picco@hp.com>
CC: Len Brown <lenb@kernel.org>, akpm@osdl.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm[2-3] ACPI issues
References: <20070131202532.GS30233@localhost> <200702010155.02119.lenb@kernel.org> <20070201164709.GA17678@localhost> <45C348B3.8000805@linux.intel.com> <20070202154205.GC17678@localhost>
In-Reply-To: <20070202154205.GC17678@localhost>
Content-Type: multipart/mixed;
 boundary="------------050108080804080804010400"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050108080804080804010400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bob Picco wrote:
> Alexey Starikovskiy wrote:	[Fri Feb 02 2007, 09:20:35AM EST]
>   
>> Bob Picco wrote:
>>     
>>> BTW, this isn't specific to rx2600. Lee Schermerhorn reported same -mm3 
>>> problem on rx8620. Stephane Eranian reported the -mm2 problem mentioned 
>>> above on rx2620.
>>>
>>> The debug information you requested is below. 
>>>
>>> thanks,
>>>
>>> bob
>>>       
>> Bob, thanks for debug information.
>> Could you please try following patch?
>>
>> Thanks,
>>     
> your welcome,
>
> It boots rx2600 and NUMA simulator successfully. The NUMA simulator has my M$
> SRAT 1.0 hack applied.
>
>   
Could you please try following patch instead of your hack?

Thanks,
    Alex.

--------------050108080804080804010400
Content-Type: text/plain;
 name="temp_fix_for_proximity_domain.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="temp_fix_for_proximity_domain.patch"

Proximity domain just became u32 what makes HP to break... Mask the

From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>

extended range for now.
---

 arch/ia64/kernel/acpi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 989ffc3..a99b0cc 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -422,8 +422,8 @@ static int get_memory_proximity_domain(s
 	int pxm;
 
 	pxm = ma->proximity_domain;
-	if (ia64_platform_is("sn2"))
-		pxm += ma->reserved << 8;
+	if (!ia64_platform_is("sn2"))
+		pxm &= 0xff;
 
 	return pxm;
 }

--------------050108080804080804010400--
