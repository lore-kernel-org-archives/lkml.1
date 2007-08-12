Return-Path: <linux-kernel-owner+w=401wt.eu-S934362AbXHLMXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362AbXHLMXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 08:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXHLMXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 08:23:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:48145 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbXHLMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 08:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZIj9iD5+ePS5aVZSJKs7tnaLpGv142VuDQ4sj72D8pEVX7O+85pm23RYOVtATPvP129wUggVeUgnrSg0+UhUkj0n4DHwSyO44N/03YSN1jY4dDtaNeNotq24vYqPh2h47HQnLmhckRVMZDa7/GAhSAG3AqUAahDTc+mPmxASg2U=
Date: Sun, 12 Aug 2007 16:23:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <fengguang.wu@gmail.com>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070812122320.GA15501@cvg>
References: <386838491.27058@ustc.edu.cn> <661de9470708110730r1267bdfdp1e76546e11b64f78@mail.gmail.com> <20070811100015.2417788e.akpm@linux-foundation.org> <46BDF965.3050402@linux.vnet.ibm.com> <20070812054831.GB8992@mail.ustc.edu.cn> <386909088.16432@ustc.edu.cn> <46BED20C.308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BED20C.308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Balbir Singh - Sun, Aug 12, 2007 at 02:55:32PM +0530]
| WU Fengguang wrote:
| > On Sun, Aug 12, 2007 at 01:48:31PM +0800, WU Fengguang wrote:
| >> On Sat, Aug 11, 2007 at 11:31:09PM +0530, Balbir Singh wrote:
| >>> Andrew Morton wrote:
| >>>> On Sat, 11 Aug 2007 20:00:12 +0530 "Balbir Singh" <balbir@linux.vnet.ibm.com> wrote:
| >>>>> Shouldn't we just not stop vm accounting for kernel threads?
| >>>>>
| >>>> Could be.  It'd help heaps if we knew which patch in -mm caused
| >>>> this, but from a quick peek it seems to me that mainline should be
| >>>> vulnerable as well.
| >>> Thats a valid point. It would be interesting to see what the overcommit
| >>> setting was, when the panic occurred.
| >> FYI, I do have nondefault overcommit settings:
| >>
| >> vm.overcommit_memory = 2
| >> vm.lowmem_reserve_ratio = 1 1
| > 
| > Yes, the bug disappears when changing to default overcommit_memory!
| > 
| 
| Great! So the problem might have existed for some time, but we never
| saw it due to default over commit values? Were you using these values
| for over commit even before?
| 
| -- 
| 	Warm Regards,
| 	Balbir Singh
| 	Linux Technology Center
| 	IBM, ISTL

So the problem is that __vm_enough_memory is just _not_ capable
to be called from a thread with OVERCOMMIT_NEVER and Fengguang's
patch does fix it. The scenario Fengguang show us is growing
from keventd that starts a new user task. So Fengguang's patch
seems right to me ;)

		Cyrill

