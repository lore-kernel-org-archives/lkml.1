Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZEUDFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZEUDFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZEUDFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:05:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63443 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbZEUDFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:05:40 -0400
Message-ID: <4A14C54F.6040808@cn.fujitsu.com>
Date: Thu, 21 May 2009 11:06:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Zhenwen Xu <helight.xu@gmail.com>
CC: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com
Subject: Re: [PATCH] remove function audit_receive_filter here in kerenl/audit.c
References: <20090521023111.GA4863@helight>
In-Reply-To: <20090521023111.GA4863@helight>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 9442c35..40fc803 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -790,6 +790,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  		}
>  		/* fallthrough */
>  	case AUDIT_LIST:
> +	case AUDIT_LIST_RULES:
>  		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
>  					   uid, seq, data, nlmsg_len(nlh),
>  					   loginuid, sessionid, sid);
> @@ -807,12 +808,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  			audit_log_end(ab);
>  			return -EPERM;
>  		}
> -		/* fallthrough */

This patch is obviously wrong.

> -	case AUDIT_LIST_RULES:
> -		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
> -					   uid, seq, data, nlmsg_len(nlh),
> -					   loginuid, sessionid, sid);
> -		break;
>  	case AUDIT_TRIM:
>  		audit_trim_trees();
>  

