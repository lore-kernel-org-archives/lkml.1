Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYBEEPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYBEEPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYBEEPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:15:36 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43737 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYBEEPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:15:35 -0500
Message-ID: <47A7E282.1080902@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2008 09:43:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeff Davis <linux@j-davis.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] badness() dramatically overcounts memory
References: <1202182480.24634.22.camel@dogma.ljc.laika.com>
In-Reply-To: <1202182480.24634.22.camel@dogma.ljc.laika.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Davis wrote:
> In oom_kill.c, one of the badness calculations is wildly inaccurate. If
> memory is shared among child processes, that same memory will be counted
> for each child, effectively multiplying the memory penalty by N, where N
> is the number of children.
> 
> This makes it almost certain that the parent will always be chosen as
> the victim of the OOM killer (assuming any substantial amount memory
> shared among the children), even if the parent and children are well
> behaved and have a reasonable and unchanging VM size.
> 
> Usually this does not actually alleviate the memory pressure because the
> truly bad process is completely unrelated; and the OOM killer must later
> kill the truly bad process.
> 
> This trivial patch corrects the calculation so that it does not count a
> child's shared memory against the parent.
> 

Hi, Jeff,

1. grep on the kernel source tells me that shared_vm is incremented only in
   vm_stat_account(), which is a NO-OP if CONFIG_PROC_FS is not defined.
2. How have you tested these patches? One way to do it would be to use the
   memory controller and set a small limit on the control group. A memory
   intensive application will soon see an OOM.

I do need to look at OOM kill sanity, my colleagues using the memory controller
have reported wrong actions taken by the OOM killer, but I am yet to analyze them.

The interesting thing is the use of total_vm and not the RSS which is used as
the basis by the OOM killer. I need to read/understand the code a bit more.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
