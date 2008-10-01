Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYJAFf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYJAFf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 01:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYJAFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 01:35:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42826 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYJAFfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 01:35:16 -0400
Date: Wed, 1 Oct 2008 14:41:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
Message-Id: <20081001144150.3faa92ea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48E30B02.3030506@linux.vnet.ibm.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
	<48E2F6A9.9010607@linux.vnet.ibm.com>
	<20081001140748.637b9831.kamezawa.hiroyu@jp.fujitsu.com>
	<48E30B02.3030506@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2008 11:00:42 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 01 Oct 2008 09:33:53 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> Can we make this patch indepedent of the flags changes and push it in ASAP.
> >>
> > Need much work....Hmm..rewrite all again ? 
> > 
> 
> I don't think you'll need to do a major rewrite? Will you? 
yes. LOCK bit is on page_cgroup->flags bit.
Then, I'll check all places which modify page_cgroup->flags again and
take lock always.
This means I'll have to check dead-lock and preemption and irq-disable, again.

> My concern is that this patch does too much to be a single patch.
> Consider someone trying to do a
> git-bisect to identify a problem? It is hard to review as well and I think the
> patch that just removes struct page member can go in faster.
> 
Please apply atomic_flags first. this later.

> It will be easier to test/debug as well, we'll know if the problem is because of
> new page_cgroup being outside struct page rather then guessing if it was the
> atomic ops that caused the problem.
> 

atomic_ops patch just rewrite exisiting behavior.

Thanks,
-Kame

