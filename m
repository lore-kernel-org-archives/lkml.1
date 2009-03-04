Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbZCDEbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbZCDEbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 23:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZCDEav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 23:30:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36769 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZCDEav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 23:30:51 -0500
Date: Wed, 4 Mar 2009 13:29:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH mmotm] cgroup: remove rcu_read_lock() from
 css_get_next()
Message-Id: <20090304132926.af5e47a0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090304042920.GA4508@in.ibm.com>
References: <20090304042920.GA4508@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 09:59:20 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> cgroup: remove rcu_read_lock() from css_get_next()
> 
> Callers of css_get_next() are already calling css_get_next()
> under rcu_read_lock() and hence there there is no need for
> css_get_next() to re-acquire rcu_read_lock(). As per the
> comments in css_get_next(), let the callers accquire the
> rcu_read_lock().
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

Yes, thank you for pointing out. This should be done by caller.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  kernel/cgroup.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3553,7 +3553,6 @@ css_get_next(struct cgroup_subsys *ss, i
>  		return NULL;
>  
>  	BUG_ON(!ss->use_id);
> -	rcu_read_lock();
>  	/* fill start point for scan */
>  	tmpid = id;
>  	while (1) {
> @@ -3577,8 +3576,6 @@ css_get_next(struct cgroup_subsys *ss, i
>  		/* continue to scan from next id */
>  		tmpid = tmpid + 1;
>  	}
> -
> -	rcu_read_unlock();
>  	return ret;
>  }
>  
> Regards,
> Bharata.
> 

