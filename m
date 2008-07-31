Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbYGaDQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbYGaDQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbYGaDQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:16:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbYGaDQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:16:17 -0400
Subject: Re: [PATCH] Fix the bug of using AUDIT_STATUS_RATE_LIMIT when set
	fail, no error output.
From: Eric Paris <eparis@redhat.com>
To: zhangxiliang <zhangxiliang@cn.fujitsu.com>
Cc: sgrubb@redhat.com, viro@zeniv.linux.org.uk,
       Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <48911F47.50606@cn.fujitsu.com>
References: <48911F47.50606@cn.fujitsu.com>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 23:15:50 -0400
Message-Id: <1217474150.2902.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 10:11 +0800, zhangxiliang wrote:
> When the "status_get->mask" is "AUDIT_STATUS_RATE_LIMIT || AUDIT_STATUS_BACKLOG_LIMIT".
> If "audit_set_rate_limit" fails and "audit_set_backlog_limit" succeeds, the "err" value will be greater than or equal to 0. It will miss the failure of rate set. 
> 
> Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>

man, it gives me the heebee jeebies with the coding style but it follows
everything else

Acked-by: Eric Paris <eparis@redhat.com>


> ---
>  kernel/audit.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index e092f1c..38a4080 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -725,9 +725,11 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  			audit_pid = new_pid;
>  			audit_nlk_pid = NETLINK_CB(skb).pid;
>  		}
> -		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT)
> +		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT) {
>  			err = audit_set_rate_limit(status_get->rate_limit,
>  						   loginuid, sessionid, sid);
> +			if (err < 0) return err;
> +		}
>  		if (status_get->mask & AUDIT_STATUS_BACKLOG_LIMIT)
>  			err = audit_set_backlog_limit(status_get->backlog_limit,
>  						      loginuid, sessionid, sid);
> -- 
> 1.5.4.2
> 
> 

