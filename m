Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYEMDqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYEMDqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYEMDpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:45:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36544
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbYEMDpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:45:53 -0400
Date: Mon, 12 May 2008 20:45:47 -0700 (PDT)
Message-Id: <20080512.204547.138851614.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: drepper@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080512201341.9ead6a9a.akpm@linux-foundation.org>
References: <200805062118.m46LI74j004096@devserv.devel.redhat.com>
	<20080512201341.9ead6a9a.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 12 May 2008 20:13:41 -0700

> On Tue, 6 May 2008 17:18:07 -0400 Ulrich Drepper <drepper@redhat.com> wrote:
> 
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -1219,6 +1219,13 @@ asmlinkage long sys_socket(int family, int type, int protocol)
> >  	struct socket *sock;
> >  	int flags;
> >  
> > +	/* Check the SOCK_* constants for consistency.  */
> > +	BUILD_BUG_ON(SOCK_CLOEXEC != O_CLOEXEC);
> > +	BUILD_BUG_ON(SOCK_NONBLOCK != O_NONBLOCK);
> > +	BUILD_BUG_ON((SOCK_MAX | SOCK_TYPE_MASK) != SOCK_TYPE_MASK);
> > +	BUILD_BUG_ON(SOCK_CLOEXEC & SOCK_TYPE_MASK);
> > +	BUILD_BUG_ON(SOCK_NONBLOCK & SOCK_TYPE_MASK);
> 
> The fifth assertion triggers with alpha allmodconfig.

Unfortunately, MIPS and PARISC look like they will as well :-/
