Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbYFDJKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbYFDJKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYFDJKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:10:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49701 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYFDJKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:10:02 -0400
Date: Wed, 4 Jun 2008 18:15:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 0/2] memcg: hierarchy support (v3)
Message-Id: <20080604181528.f4c94743.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830806040159o648392a1l3dbd84d9c765a847@mail.gmail.com>
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830806040159o648392a1l3dbd84d9c765a847@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 01:59:32 -0700
"Paul Menage" <menage@google.com> wrote:

> Hi Kame,
> 
> I like the idea of keeping the kernel simple, and moving more of the
> intelligence to userspace.
> 
thanks.

> It may need the kernel to expose a bit more in the way of VM details,
> such as memory pressure, OOM notifications, etc, but as long as
> userspace can respond quickly to memory imbalance, it should work
> fine. We're doing something a bit similar using cpusets and fake NUMA
> at Google - the principle of juggling memory between cpusets is the
> same, but the granularity is much worse :-)
> 
yes, next problem is adding interfaces. but we have to investigate
what is principal.


> On Tue, Jun 3, 2008 at 9:58 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >  - supported hierarchy_model parameter.
> >   Now, no_hierarchy and hardwall_hierarchy is implemented.
> 
> Should we try to support hierarchy and non-hierarchy cgroups in the
> same tree? Maybe we should just enforce the restrictions that:
> 
> - the hierarchy mode can't be changed on a cgroup if you have children
> or any non-zero usage/limit
> - a cgroup inherits its parent's hierarchy mode.
> 
Ah, my patch does it (I think).  explanation is bad.

- mem cgroup's mode can be changed against ROOT node which has no children.
- a child inherits parent's mode.

Thanks,
-Kame


