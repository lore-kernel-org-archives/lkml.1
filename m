Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbYEFB7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbYEFB7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbYEFB7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:59:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000AbYEFB7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:59:40 -0400
Date: Mon, 5 May 2008 18:58:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
Message-Id: <20080505185850.789d870a.akpm@linux-foundation.org>
In-Reply-To: <200805050342.m453gktl029817@devserv.devel.redhat.com>
References: <200805050342.m453gktl029817@devserv.devel.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008 23:42:46 -0400 Ulrich Drepper <drepper@redhat.com> wrote:

> +static const struct flags_rmap sock_file_flags_remap[] = {
> +	{ SOCK_CLOEXEC, O_CLOEXEC },
> +};
> +
>  asmlinkage long sys_socket(int family, int type, int protocol)
>  {
>  	int retval;
>  	struct socket *sock;
> +	int fflags;
> +
> +	type = flags_remap(sock_file_flags_remap,
> +			   ARRAY_SIZE(sock_file_flags_remap),
> +			   type, &fflags);

oh, so that's what it does.

afaict we only ever remap one or two flags.  Would it not be more efficient
to do that inline?  Something along the lines of:

	type = flag_remap(type, &fflags, SOCK_whatever, O_whatever);
	type = flag_remap(type, &fflags, SOCK_whatever2, O_whatever2);

?
