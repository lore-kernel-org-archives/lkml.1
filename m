Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYKFBfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYKFBfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 20:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYKFBfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 20:35:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40207 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYKFBfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 20:35:33 -0500
Date: Thu, 6 Nov 2008 10:34:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       Christoph Lameter <cl@linux-foundation.org>, dfults@sgi.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-Id: <20081106103455.f3277a72.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0811051347240.21365@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	<20081104124753.fb1dde5a.akpm@linux-foundation.org>
	<1225831988.7803.1939.camel@twins>
	<20081104131637.68fbe055.akpm@linux-foundation.org>
	<1225833710.7803.1993.camel@twins>
	<20081104135004.f1717fcf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041601100.5077@quilx.com>
	<20081104143534.b5c16147.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041648350.6254@quilx.com>
	<20081104153610.bbfd5ed8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811042036000.31167@quilx.com>
	<20081104190505.769b93ec.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811050747040.11867@quilx.com>
	<20081105104145.abd6fc91.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811051415360.31450@quilx.com>
	<20081105123150.d6628805.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811051434300.31450@quilx.com>
	<20081105125603.36d0c222.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0811051347240.21365@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 14:04:42 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> > So the world wouldn't end if we just didn't merge it.  Those users
> > stick with their workarounds and the kernel remains simpler and
> > smaller.
> > 
> 
> Agreed.  This patchset is admittedly from a different time when cpusets 
> was the only relevant extension that needed to be done.
> 
BTW, what is the problem this patch wants to fix ?
  1. avoid slow-down of memory allocation by triggering write-out earlier.
  2. avoid OOM by throttoling dirty pages.

About 1, memcg's diry_ratio can help if mounted as
   mount -t cgroup none /somewhere/  -o cpuset,memory
(If the user can accept overheads of memcg.)
If implemented.

About 2, A Google guy posted OOM handler cgroup to linux-mm.

> > How do we work out which is the best choice here?  I don't have enough
> > information to do this.
> > 
> 
> If we are to support memcg-specific dirty ratios, that requires the 
> aforementioned statistics to be collected so that the calculation is even 
> possible.  The series at 
> 
> 	http://marc.info/?l=linux-kernel&m=122123225006571
> 	http://marc.info/?l=linux-kernel&m=122123241106902
> 
yes. we(memcg) need this kind of.

> is a step in that direction, although I'd prefer to see NR_UNSTABLE_NFS to 
> be extracted separately from MEM_CGROUP_STAT_FILE_DIRTY so 
> throttle_vm_writeout() can also use the new statistics.
> 
Thank you for input.

Thanks,
-Kame


