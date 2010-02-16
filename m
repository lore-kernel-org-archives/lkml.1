Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0BPA0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:26:43 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38316 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab0BPA0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:26:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Feb 2010 09:23:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
Message-Id: <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com>
	<20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010 16:14:22 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Tue, 16 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > > If /proc/sys/vm/panic_on_oom is set to 2, the kernel will panic
> > > regardless of whether the memory allocation is constrained by either a
> > > mempolicy or cpuset.
> > > 
> > > Since mempolicy-constrained out of memory conditions now iterate through
> > > the tasklist and select a task to kill, it is possible to panic the
> > > machine if all tasks sharing the same mempolicy nodes (including those
> > > with default policy, they may allocate anywhere) or cpuset mems have
> > > /proc/pid/oom_adj values of OOM_DISABLE.  This is functionally equivalent
> > > to the compulsory panic_on_oom setting of 2, so the mode is removed.
> > > 
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > 
> > NACK. In an enviroment which depends on cluster-fail-over, this is useful
> > even if in such situation.
> > 
> 
> You don't understand that the behavior has changed ever since 
> mempolicy-constrained oom conditions are now affected by a compulsory 
> panic_on_oom mode, please see the patch description.  It's absolutely 
> insane for a single sysctl mode to panic the machine anytime a cpuset or 
> mempolicy runs out of memory and is more prone to user error from setting 
> it without fully understanding the ramifications than any use it will ever 
> do.  The kernel already provides a mechanism for doing this, OOM_DISABLE.  
> if you want your cpuset or mempolicy to risk panicking the machine, set 
> all tasks that share its mems or nodes, respectively, to OOM_DISABLE.  
> This is no different from the memory controller being immune to such 
> panic_on_oom conditions, stop believing that it is the only mechanism used 
> in the kernel to do memory isolation.
> 
You don't explain why "we _have to_ remove API which is used"

Thanks,
-Kame



