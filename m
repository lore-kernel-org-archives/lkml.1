Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbYDUKmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbYDUKmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbYDUKgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:36:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39722 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760032AbYDUKgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:36:07 -0400
Date: Mon, 21 Apr 2008 19:40:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, shiwh@cn.fujitsu.com,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
Message-Id: <20080421194023.c8d9733d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <480C6AA1.5000607@linux.vnet.ibm.com>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0804210004470.1630@blonde.site>
	<20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com>
	<20080420232427.1b399104.akpm@linux-foundation.org>
	<480C347C.6060702@linux.vnet.ibm.com>
	<20080421064725.GA32214@balbir.in.ibm.com>
	<1208770925.7115.167.camel@twins>
	<480C6AA1.5000607@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 15:51:21 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> >> This would enable the memory controller by default, it can be disabled
> >> using cgroup_disable=memory at boot time.
> > 
> > how about working on a runtime switch that only enables the whole
> > memcgroup machinery when an actual cgroup gets created - and disable it
> > again once the last cgroup goes.
> > 
> 
> Sounds like an interesting option to explore. I'll explore that a bit more.
> 
Maybe force_empty() will be a help for disabling ;)

- stop accountig new pages.
- calling force_empty if there are no childs.

problem is enabling.

A problem will be that we cannot account page-cache again because
it's on radix-tree when cgroup is re-enabled.


Thanks,
-Kame

