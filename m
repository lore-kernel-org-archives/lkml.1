Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab0BQC11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:27:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42706 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335Ab0BQC10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:27:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 11:23:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
Message-Id: <20100217112353.b90f732a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com>
	<20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
	<20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com>
	<20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
	<20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com>
	<20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com>
	<20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 11:13:19 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 16 Feb 2010 17:58:05 -0800 (PST)
> David Rientjes <rientjes@google.com> wrote:
> 
> > On Tue, 16 Feb 2010, David Rientjes wrote:
> > 
> > > Ok, I'll eliminate pagefault_out_of_memory() and get it to use 
> > > out_of_memory() by only checking for constrained_alloc() when
> > > gfp_mask != 0.
> > > 
> > 
> > What do you think about making pagefaults use out_of_memory() directly and 
> > respecting the sysctl_panic_on_oom settings?
> > 
> 
> I don't think this patch is good. Because several memcg can
> cause oom at the same time independently, system-wide oom locking is
> unsuitable.

And basically. memcg's oom means "the usage over the limits!!" and does
never means "resouce is exhausted!!".

Then, marking OOM to zones sounds strange. You can cause oom in 64MB memcg
in 64GB system.

Thanks,
-Kame

