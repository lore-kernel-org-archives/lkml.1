Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYEQNSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYEQNSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 09:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYEQNSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 09:18:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:18061 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbYEQNSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 09:18:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,500,1204531200"; 
   d="scan'208";a="329381264"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s laptop
Date: Sat, 17 May 2008 06:21:18 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com>
In-reply-to: <E1JxGth-0001te-S4@closure.thunk.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s laptop
Thread-Index: Aci38Q73SE0LOdyUT/+f4x49jMSNpQAL1+3g
References: <E1JxGth-0001te-S4@closure.thunk.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>, <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 17 May 2008 13:18:36.0284 (UTC) FILETIME=[836333C0:01C8B820]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Theodore Ts'o [mailto:tytso@mit.edu] 
>Sent: Saturday, May 17, 2008 12:32 AM
>To: linux-kernel@vger.kernel.org
>Cc: Pallipadi, Venkatesh
>Subject: REGRESSION: 2.6.26-rc2-git4: X server failed start on 
>X61s laptop
>
>
>The X server failed to come up using the Intel driver, and forced a
>fallback to the 800x600 VESA server.  This was on my Lenovo X61s laptop
>with an Intel chipset, running Ubuntu Gutsy.  When it failed, 
>there were
>a large number of these errors in the /var/log/messages:
>
>mtrr: type mismatch for e0760000,10000 old: write-back new: 
>write-combining
>mtrr: type mismatch for e0740000,20000 old: write-back new: 
>write-combining
>mtrr: type mismatch for e0700000,40000 old: write-back new: 
>write-combining
>mtrr: type mismatch for e0600000,100000 old: write-back new: 
>write-combining
>mtrr: type mismatch for e0400000,200000 old: write-back new: 
>write-combining
>mtrr: type mismatch for e0000000,400000 old: write-back new: 
>write-combining
>      ...
>
>On kernels where this error did not occur during the bisect, 
>there would
>still be one of these messages:
>
>mtrr: type mismatch for e0000000,10000000 old: write-back new: 
>write-combining
>
>... but the X server would correctly start.
>
>The git bisect identified this commit as the guilty one:
>
>1c12c4cf9411eb130b245fa8d0fbbaf989477c7b is first bad commit
>commit 1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
>Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
>Date:   Wed May 14 16:05:51 2008 -0700
>
>    mprotect: prevent alteration of the PAT bits
>    
>    There is a defect in mprotect, which lets the user change 
>the page cache
>    type bits by-passing the kernel reserve_memtype and free_memtype
>    wrappers.  Fix the problem by not letting mprotect change 
>the PAT bits.
>    


Can you please send the complete dmesg after X failure, with patch here
and debugpat boot option.
http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2657.html

Thanks,
Venki
