Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbZIQGxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbZIQGxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 02:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZIQGxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 02:53:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:46705 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743AbZIQGxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 02:53:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,402,1249282800"; 
   d="scan'208";a="188602902"
Date: Thu, 17 Sep 2009 14:53:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Subject: Re: [RFC][PATCH][bugfix] more checks for negative f_pos handling v3
Message-ID: <20090917065323.GA9016@localhost>
References: <20090914032901.GA16189@localhost> <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com> <20090916142956.9998ba71.kamezawa.hiroyu@jp.fujitsu.com> <20090917145319.97f67737.kamezawa.hiroyu@jp.fujitsu.com> <20090917150726.9acb0f40.kamezawa.hiroyu@jp.fujitsu.com> <20090917062124.GA6964@localhost> <20090917153119.8c3a8efe.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917153119.8c3a8efe.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 02:31:19PM +0800, KAMEZAWA Hiroyuki wrote:
> > How about make the fields aligned? That would look much nicer :)
> > 
> checkpatch.pl complains  agaisnt [ 5]...but ok, ajust "=" placement.

How about this? checkpatch won't complain on it :)

} devlist[] = {
	[1] = {     "mem",     &mem_fops, &directly_mappable_cdev_bdi,  true },
#ifdef CONFIG_DEVKMEM
	[2] = {    "kmem",    &kmem_fops, &directly_mappable_cdev_bdi,  true },
#endif
	[3] = {    "null",    &null_fops,                        NULL, false },
#ifdef CONFIG_DEVPORT
	[4] = {    "port",    &port_fops,                        NULL, false },
#endif
	[5] = {    "zero",    &zero_fops,                   &zero_bdi, false },
	[6] = {    "full",    &full_fops,                        NULL, false },
	[7] = {  "random",  &random_fops,                        NULL, false },
	[9] = { "urandom", &urandom_fops,                        NULL, false },
	[11] = {   "kmsg",    &kmsg_fops,                        NULL, false },
#ifdef CONFIG_CRASH_DUMP
	[12] = { "oldmem",  &oldmem_fops,                        NULL, false },
#endif
};

Thanks,
Fengguang

