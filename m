Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbZCBGVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbZCBGVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 01:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZCBGVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 01:21:14 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60307 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCBGVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 01:21:13 -0500
Date: Mon, 2 Mar 2009 15:19:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] Memory controller soft limit interface (v3)
Message-Id: <20090302151953.f222c761.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090302060726.GH11421@balbir.in.ibm.com>
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
	<20090301063011.31557.42094.sendpatchset@localhost.localdomain>
	<20090302110323.1a9b9e6b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090302044631.GE11421@balbir.in.ibm.com>
	<20090302143518.43f5fcc2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090302060726.GH11421@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 11:37:26 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 14:35:18]:
> 
> > On Mon, 2 Mar 2009 10:16:31 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 11:03:23]:
> > > 
> > > > On Sun, 01 Mar 2009 12:00:11 +0530
> > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > 
> > > > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > > > 
> > > > > Changelog v2...v1
> > > > > 1. Add support for res_counter_check_soft_limit_locked. This is used
> > > > >    by the hierarchy code.
> > > > > 
> > > > > Add an interface to allow get/set of soft limits. Soft limits for memory plus
> > > > > swap controller (memsw) is currently not supported. Resource counters have
> > > > > been enhanced to support soft limits and new type RES_SOFT_LIMIT has been
> > > > > added. Unlike hard limits, soft limits can be directly set and do not
> > > > > need any reclaim or checks before setting them to a newer value.
> > > > > 
> > > > > Kamezawa-San raised a question as to whether soft limit should belong
> > > > > to res_counter. Since all resources understand the basic concepts of
> > > > > hard and soft limits, it is justified to add soft limits here. Soft limits
> > > > > are a generic resource usage feature, even file system quotas support
> > > > > soft limits.
> > > > > 
> > > > I don't convice adding more logics to res_counter is a good to do, yet.
> > > >
> > > 
> > > Even though it is extensible and you pay the cost only when soft
> > > limits is turned on? Can you show me why you are not convinced?
> > >  
> > Inserting more codes (like "if") to res_counter itself is not welcome..
> > I think res_counter is too complex as counter already.
> >
> 
> Darn.. we better stop all code development!
>  
I don't say such a thing. My point is we have to keep res_counter as light-weight
as possible. If there are alternatives, we should use that.

Thanks,
-Kame



