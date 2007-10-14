Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbXJNWbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbXJNWbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 18:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbXJNWba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 18:31:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36072 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXJNWb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 18:31:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       David Miller <davem@davemloft.net>
Subject: Re: Don't leak 'listeners' in netlink_kernel_create()
References: <200710142337.01059.jesper.juhl@gmail.com>
Date: Sun, 14 Oct 2007 16:30:06 -0600
In-Reply-To: <200710142337.01059.jesper.juhl@gmail.com> (Jesper Juhl's message
	of "Sun, 14 Oct 2007 23:37:00 +0200")
Message-ID: <m1hckt5nyp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl <jesper.juhl@gmail.com> writes:

> From: Jesper Juhl <jesper.juhl@gmail.com>
> Subject: Don't leak 'listeners' in netlink_kernel_create()
>
> The Coverity checker spotted that we'll leak the storage allocated 
> to 'listeners' in netlink_kernel_create() when the
>   if (!nl_table[unit].registered)
> check is false.
>
> This patch avoids the leak.
>
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

This patch appears trivially correct to me.
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>
>  af_netlink.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- linux-2.6/net/netlink/af_netlink.c~	2007-10-14 23:29:50.000000000 +0200
> +++ linux-2.6/net/netlink/af_netlink.c	2007-10-14 23:29:50.000000000 +0200
> @@ -1378,6 +1378,8 @@ netlink_kernel_create(struct net *net, i
>  		nl_table[unit].cb_mutex = cb_mutex;
>  		nl_table[unit].module = module;
>  		nl_table[unit].registered = 1;
> +	} else {
> +		kfree(listeners);
>  	}
>  	netlink_table_ungrab();
>  
