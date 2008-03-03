Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbYCCXeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbYCCXeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYCCXdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:33:40 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9691 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbYCCXdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:33:38 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH 4/9] Netlink: Use generic LSM hook
Date: Mon, 3 Mar 2008 18:33:27 -0500
User-Agent: KMail/1.9.7
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
References: <20080301194752.GA19636@ubuntu> <20080301195622.GE19636@ubuntu>
In-Reply-To: <20080301195622.GE19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031833.27700.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008 2:56:22 pm Ahmed S. Darwish wrote:
> Don't use SELinux exported selinux_get_task_sid symbol.
> Use the generic LSM equivalent instead.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Reviewed-by: Paul Moore <paul.moore@hp.com>

> ---
>
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 1ab0da2..61fd277 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -54,7 +54,6 @@
>  #include <linux/mm.h>
>  #include <linux/types.h>
>  #include <linux/audit.h>
> -#include <linux/selinux.h>
>  #include <linux/mutex.h>
>
>  #include <net/net_namespace.h>
> @@ -1239,7 +1238,7 @@ static int netlink_sendmsg(struct kiocb *kiocb,
> struct socket *sock, NETLINK_CB(skb).pid	= nlk->pid;
>  	NETLINK_CB(skb).dst_group = dst_group;
>  	NETLINK_CB(skb).loginuid = audit_get_loginuid(current);
> -	selinux_get_task_sid(current, &(NETLINK_CB(skb).sid));
> +	security_task_getsecid(current, &(NETLINK_CB(skb).sid));
>  	memcpy(NETLINK_CREDS(skb), &siocb->scm->creds, sizeof(struct
> ucred));
>
>  	/* What can I do? Netlink is asynchronous, so that



-- 
paul moore
linux security @ hp
