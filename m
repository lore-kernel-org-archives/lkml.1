Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbYBEXCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbYBEXCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYBEXCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:02:47 -0500
Received: from ns1.siteground137.com ([67.15.250.10]:46447 "EHLO
	serv01.siteground137.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbYBEXCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:02:46 -0500
X-Greylist: delayed 70080 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 18:02:46 EST
Subject: Re: [PATCH] badness() dramatically overcounts memory
From: Jeff Davis <linux@j-davis.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <47A7E282.1080902@linux.vnet.ibm.com>
References: <1202182480.24634.22.camel@dogma.ljc.laika.com>
	 <47A7E282.1080902@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 15:02:41 -0800
Message-Id: <1202252561.24634.64.camel@dogma.ljc.laika.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground137.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - j-davis.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 09:43 +0530, Balbir Singh wrote:
> 1. grep on the kernel source tells me that shared_vm is incremented only in
>    vm_stat_account(), which is a NO-OP if CONFIG_PROC_FS is not defined.

I see, thanks for pointing that out. Is there another way do you think?
Would the penalty be to high to enable vm_stat_account when
CONFIG_PROC_FS is not defined?

Or perhaps my patch would only have an effect when CONFIG_PROC_FS is set
(which is default)?

> 2. How have you tested these patches? One way to do it would be to use the
>    memory controller and set a small limit on the control group. A memory
>    intensive application will soon see an OOM.

I have done a quick test a while back when I first wrote the patch. I
will test more thoroughly now.

> The interesting thing is the use of total_vm and not the RSS which is used as
> the basis by the OOM killer. I need to read/understand the code a bit more.

RSS makes more sense to me as well.

To me, it makes no sense to count shared memory, because killing a
process doesn't free the shared memory.

Regards,
	Jeff Davis

