Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZCQOAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZCQOAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZCQN7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:59:54 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:45709 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbZCQN7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:59:53 -0400
Date: Tue, 17 Mar 2009 19:29:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
	cpuacct_charge() safe when rcupreempt is used.
Message-ID: <20090317135938.GV16897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090317061754.GD3314@in.ibm.com> <49BF42FB.4030103@cn.fujitsu.com> <20090317073649.GH3314@in.ibm.com> <20090317131251.GU16897@balbir.in.ibm.com> <1237296361.7867.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1237296361.7867.16.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-03-17 14:26:01]:

> On Tue, 2009-03-17 at 18:42 +0530, Balbir Singh wrote:
> 
> > I'd like to get the patches in -tip and see the results, I would
> > recommend using percpu_counter_sum() while reading the data as an
> > enhancement to this patch. If user space does not overwhelm with a lot
> > of reads, sum would work out better.
> 
> You trust userspace? I'd rather not.
>

Fair enough.. A badly written application monitor can frequently read
this data and cause horrible performance issues. On the other hand
large number of CPUs can make the lag even worse. Is it time yet for
percpu_counter batch numbers? I've tested this patch and the results
were not badly off the mark. 

-- 
	Balbir
