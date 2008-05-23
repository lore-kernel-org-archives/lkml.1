Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbYEWFXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbYEWFXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYEWFXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:23:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbYEWFXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:23:35 -0400
Date: Thu, 22 May 2008 22:22:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
Message-Id: <20080522222246.0526f8f8.akpm@linux-foundation.org>
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

On alpha the

	BUILD_BUG_ON(SOCK_NONBLOCK & SOCK_TYPE_MASK);

seems to have gone away, but now

	BUILD_BUG_ON(SOCK_NONBLOCK != O_NONBLOCK);

is triggering.

