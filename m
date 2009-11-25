Return-Path: <linux-kernel-owner+w=401wt.eu-S934525AbZKYEJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525AbZKYEJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 23:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934516AbZKYEJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 23:09:55 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51735 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934498AbZKYEJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 23:09:54 -0500
Date: Wed, 25 Nov 2009 09:39:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       stable <stable@kernel.org>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH -mmotm] memcg: avoid oom-killing innocent task
	in case of use_hierarchy
Message-ID: <20091125040933.GE3365@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2009-11-24 14:57:59]:

> task_in_mem_cgroup(), which is called by select_bad_process() to check whether
> a task can be a candidate for being oom-killed from memcg's limit, checks
> "curr->use_hierarchy"("curr" is the mem_cgroup the task belongs to).
> 
> But this check return true(it's false positive) when:
> 
> 	<some path>/00		use_hierarchy == 0	<- hitting limit
> 	  <some path>/00/aa	use_hierarchy == 1	<- "curr"
> 
> This leads to killing an innocent task in 00/aa. This patch is a fix for this
> bug. And this patch also fixes the arg for mem_cgroup_print_oom_info(). We
> should print information of mem_cgroup which the task being killed, not current,
> belongs to.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Balbir
