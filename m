Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYEMDOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYEMDOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbYEMDOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:14:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbYEMDOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:14:30 -0400
Date: Mon, 12 May 2008 20:13:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
Message-Id: <20080512201341.9ead6a9a.akpm@linux-foundation.org>
In-Reply-To: <200805062118.m46LI74j004096@devserv.devel.redhat.com>
References: <200805062118.m46LI74j004096@devserv.devel.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 17:18:07 -0400 Ulrich Drepper <drepper@redhat.com> wrote:

> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -1219,6 +1219,13 @@ asmlinkage long sys_socket(int family, int type, int protocol)
>  	struct socket *sock;
>  	int flags;
>  
> +	/* Check the SOCK_* constants for consistency.  */
> +	BUILD_BUG_ON(SOCK_CLOEXEC != O_CLOEXEC);
> +	BUILD_BUG_ON(SOCK_NONBLOCK != O_NONBLOCK);
> +	BUILD_BUG_ON((SOCK_MAX | SOCK_TYPE_MASK) != SOCK_TYPE_MASK);
> +	BUILD_BUG_ON(SOCK_CLOEXEC & SOCK_TYPE_MASK);
> +	BUILD_BUG_ON(SOCK_NONBLOCK & SOCK_TYPE_MASK);

The fifth assertion triggers with alpha allmodconfig.
