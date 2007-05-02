Return-Path: <linux-kernel-owner+w=401wt.eu-S2993044AbXEBLA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993044AbXEBLA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993049AbXEBLAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:00:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43781 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993044AbXEBLAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:00:24 -0400
Date: Wed, 2 May 2007 16:30:22 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>, ntl@pobox.com,
       Andrew Morton <akpm@linux-foundation.org>, ashok.raj@intel.com,
       heiko.carstens@de.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: /sys/devices/system/cpu/*: Present cpus or Possible cpus
Message-ID: <20070502110022.GA13040@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Looking at the topology_init() code, I observe that the meaning of
the cpuX/ directory entries in /sys/devices/system/cpu/ might be
different for different architectures. 

Looks like, in case of i386, ia64, m32, mips etc, the cpuX directory entries
represent the "present cpus".

However, in case of powerpc, s390 etc, the cpuX entries represent the
"possible cpus".

Wondering if there is any particular reason for this discrepancy.
I am not entirely surely if it's due cpu hotplug because 
both i386 and powerpc support it!

When I do a 
"echo 1 > /sys/devices/system/cpu/cpuX/online" on a power box as root, 
I might get "-bash: echo: write error: Invalid argument" 
because cpuX might not be present!
In case of lpar, cpu_present_map need not necessarily be equal to
cpu_possible_map, so the above error is observable.

Is this discrepency intentional ?
Or is it due to the fact that in most cases,
cpu_present_map == cpu_possible_map, so lets not bother about it :-?

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
