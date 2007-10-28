Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbXJ1Wp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbXJ1Wp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXJ1WpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:45:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53065 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXJ1WpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:45:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: webmaster@dragonslave.de, akpm <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Michal Januszewski <spock@gentoo.org>
Subject: Re: [PATCH] sysctl: fix token-ring procname
References: <200710252037.09667.dex@dragonslave.de>
	<20071028152533.7606cf45.randy.dunlap@oracle.com>
Date: Sun, 28 Oct 2007 16:44:29 -0600
In-Reply-To: <20071028152533.7606cf45.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Sun, 28 Oct 2007 15:25:33 -0700")
Message-ID: <m1wst6q2pe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Eric W. Biederman <ebiederm@xmission.com>
>
> Correct the token-ring sysctl procname.
>
> Reported by: Daniel Exner <dex@dragonslave.de>:
>
> Ah, and token ring tells me something like
> "/net/token-ring ,3.14 sysctl failed check procname does not match binary path 
> procname"
> But kernel boots otherwise and I got no chance to test tr itself is working.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

"token-ring" is the historical name we have used in /proc/sys despite it
being abbreviated tr in the kernel.  So this fix is definitely
correct.

Sorry about that.  Given this bug and the atalk bug it looks like
I failed to QA the number to name mapping properly under net/.
I just looked at those entries again and I don't see any other
entries under net/ that have problems.

Hopefully this is the last of my silly bugs in this table.

Eric



> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  kernel/sysctl_check.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.24-rc1.orig/kernel/sysctl_check.c
> +++ linux-2.6.24-rc1/kernel/sysctl_check.c
> @@ -738,7 +738,7 @@ static struct trans_ctl_table trans_net_
>  	{ NET_ROSE,		"rose",		trans_net_rose_table },
>  	{ NET_IPV6,		"ipv6",		trans_net_ipv6_table },
>  	{ NET_X25,		"x25",		trans_net_x25_table },
> -	{ NET_TR,		"tr",		trans_net_tr_table },
> +	{ NET_TR,		"token-ring",	trans_net_tr_table },
>  	{ NET_DECNET,		"decnet",	trans_net_decnet_table },
>  	/*  NET_ECONET not used */
>  	{ NET_SCTP,		"sctp",		trans_net_sctp_table },
