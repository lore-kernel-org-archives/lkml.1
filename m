Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbYEAEdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbYEAEdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759890AbYEAEdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:33:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47388 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbYEAEdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:33:03 -0400
Date: Wed, 30 Apr 2008 21:32:59 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 09/10] Integrate the ridr code into IPC code
Message-ID: <20080501043258.GH30274@tpepper-t42p.dolavim.us>
References: <20080429143304.741001000@bull.net> <20080429143731.697064000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429143731.697064000@bull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29 Apr at 16:33:13 +0200 Nadia.Derbey@bull.net said:
> [PATCH 09/10]
> 
> This patche makes the ipc ode use the ridr API.

Superfluous except...

> @@ -699,18 +695,13 @@ struct kern_ipc_perm *ipc_lock(struct ip
>  	struct kern_ipc_perm *out;
>  	int lid = ipcid_to_idx(id);
> 
> -	down_read(&ids->rw_mutex);
> -
>  	rcu_read_lock();
> -	out = idr_find(&ids->ipcs_idr, lid);
> +	out = ridr_find(&ids->ipcs_ridr, lid);
>  	if (out == NULL) {
>  		rcu_read_unlock();
> -		up_read(&ids->rw_mutex);
>  		return ERR_PTR(-EINVAL);
>  	}
> 
> -	up_read(&ids->rw_mutex);
> -

...the removal of the rw_mutex down/up_read().


-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
