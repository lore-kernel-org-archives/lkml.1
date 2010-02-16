Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab0BPIO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:14:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44968 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab0BPIO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:14:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Feb 2010 17:10:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
Message-Id: <20100216171051.aebbffe5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100216080817.GK5723@laptop>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com>
	<20100216062035.GA5723@laptop>
	<alpine.DEB.2.00.1002152252310.2745@chino.kir.corp.google.com>
	<20100216072047.GH5723@laptop>
	<alpine.DEB.2.00.1002152342120.7470@chino.kir.corp.google.com>
	<20100216080817.GK5723@laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 19:08:17 +1100
Nick Piggin <npiggin@suse.de> wrote:

> On Mon, Feb 15, 2010 at 11:53:33PM -0800, David Rientjes wrote:
> > On Tue, 16 Feb 2010, Nick Piggin wrote:
> > 
> > > > Because it is inconsistent at the user's expense, it has never panicked 
> > > > the machine for memory controller ooms, so why is a cpuset or mempolicy 
> > > > constrained oom conditions any different?
> > > 
> > > Well memory controller was added later, wasn't it? So if you think
> > > that's a bug then a fix to panic on memory controller ooms might
> > > be in order.
> > > 
> > 
> > But what about the existing memcg users who set panic_on_oom == 2 and 
> > don't expect the memory controller to be influenced by that?
> 
> But that was a bug in the addition of the memory controller. Either the
> documentation should be fixed, or the implementation should be fixed.
> 
I'll add a documentation to memcg. As

"When you exhaust memory resource under memcg, oom-killer may be invoked.
 But in this case, the system never panics even when panic_on_oom is set."

Maybe I should add "memcg_oom_notify (netlink message or file-decriptor or some".
Because memcg's oom is virtual oom, automatic management software can show
report to users and can do fail-over. I'll consider something useful for
memcg oom-fail-over instead of panic. In the simplest case, cgroup's notiifer
file descriptor can be used.

Thanks,
-Kame

