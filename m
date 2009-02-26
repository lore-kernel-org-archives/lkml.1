Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZBZCzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZBZCzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZBZCzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:55:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62417 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZBZCzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:55:41 -0500
Message-ID: <49A604BA.9090407@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 10:55:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 1/2] New cgroup subsystem API (->initialize())
References: <20090225105730.GA4008@in.ibm.com> <20090225105831.GB4008@in.ibm.com>
In-Reply-To: <20090225105831.GB4008@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> From: Balaji Rao <balajirrao@gmail.com>
> 
> cgroup: Add ->initialize() to cgroup_subsys structure
> 
> Some cgroup subsystems (like cpu controller) would need subsystem
> specific initialization. Such subsystems can define ->initialize()
> which gets called during cgroup_init() (and not cgroup_init_early()).
> 

I think it's better to avoid adding this.

It would be best if we can add a hook to initialize init_task_group.stat where
kmalloc is available but acount_xxx_time() hasn't been called. Otherwise, we
have to check (tg->stat == NULL) in account_task_group_time(), then why not add
a hook in smp_init_smp() to do initialization?


