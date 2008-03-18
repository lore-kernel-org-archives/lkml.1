Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYCSTdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYCSTdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYCST1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:27:06 -0400
Received: from over.ny.us.ibm.com ([32.97.182.150]:46215 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYCST0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:26:51 -0400
Subject: Re: [RFC][2/3] Account and control virtual address space
	allocations
From: Dave Hansen <haveblue@us.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47DF1760.9030908@linux.vnet.ibm.com>
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
	 <20080316173005.8812.88290.sendpatchset@localhost.localdomain>
	 <1205772790.18916.17.camel@nimitz.home.sr71.net>
	 <47DF1760.9030908@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 10:11:16 -0700
Message-Id: <1205860276.8872.20.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-18 at 06:44 +0530, Balbir Singh wrote: 
> > If you're going to do this, I think you need a couple of phases.  
> > 
> > 1. update the vm_(un)acct_memory() functions to take an mm
> 
> There are other problems
> 
> 1. vm_(un)acct_memory is conditionally dependent on VM_ACCOUNT. Look at
> shmem_(un)acct_size for example

Yeah, but if VM_ACCOUNT isn't set, do you really want the controller
accounting for them?  It's there for a reason. :)

The shmem_acct_size() helpers look good.  I wonder if we should be using
that kind of things more generically.

> 2. These routines are not called from all contexts that we care about (look at
> insert_special_mapping())

Could you explain why "we" care about it and why it isn't accounted for
now?

-- Dave

