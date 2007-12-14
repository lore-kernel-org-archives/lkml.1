Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbXLNRwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbXLNRwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbXLNRv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:51:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753607AbXLNRv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:51:56 -0500
Date: Fri, 14 Dec 2007 09:50:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>, stable@kernel.org,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-Id: <20071214095023.b5327703.akpm@linux-foundation.org>
In-Reply-To: <20071214161637.GA2687@linux.vnet.ibm.com>
References: <20071213123333.GA16905@linux.vnet.ibm.com>
	<20071213132326.GC16905@linux.vnet.ibm.com>
	<20071213151847.GB5676@linux.vnet.ibm.com>
	<20071213162936.GA7635@suse.de>
	<20071213164658.GA30865@linux.vnet.ibm.com>
	<20071213175423.GA2977@linux.vnet.ibm.com>
	<476295FF.1040202@gmail.com>
	<20071214154711.GD23670@linux.vnet.ibm.com>
	<4762A721.7080400@gmail.com>
	<20071214161637.GA2687@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 21:46:37 +0530 Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> On Sat, Dec 15, 2007 at 12:54:09AM +0900, Tejun Heo wrote:
> > Dhaval Giani wrote:
> > > XXX sysfs_page_cnt=1
> > 
> > Hmm.. so, sysfs r/w buffer wasn't the culprit.  I'm curious what eats up
> > all your low memory.  Please do the following.
> > 
> > 1. Right after boot, record /proc/meminfo and slabinfo.
> > 
> > 2. After or near OOM, record /proc/meminfo and slabinfo.  This can be
> > tricky but if your machine reliably OOMs after 10mins, run it for 9mins
> > and capturing the result should show enough.
> > 
> 
> Attached. The results are after oom, but i think about a min or so after
> that. I missed the oom point.

Looking back at your original oom-killer output: something has consumed all
your ZONE_NORMAL memory and we cannot tell what it is.

Please run 2.6.24-rc5-mm1 again (with CONFIG_PAGE_OWNER=y) and take a peek
at the changelog in
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/broken-out/page-owner-tracking-leak-detector.patch.

Build up Documentation/page_owner.c then cause the leak to happen then
execute page_owner.

Thanks.
