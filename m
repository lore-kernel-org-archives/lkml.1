Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZIYAWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZIYAWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZIYAWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:22:50 -0400
Received: from sajino.sajinet.com.pe ([76.74.239.193]:52798 "EHLO
	sajino.sajinet.com.pe" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZIYAWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:22:50 -0400
Date: Fri, 25 Sep 2009 00:22:54 +0000
From: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EPOLL_CTL_SET operatin for epoll_ctl when using
	EPOLLONESHOT
Message-ID: <20090925002254.GA16356@sajinet.com.pe>
References: <1253831539-4506-1-git-send-email-carenas@sajinet.com.pe> <alpine.DEB.2.00.0909241641100.1164@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0909241641100.1164@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 04:46:20PM -0700, Davide Libenzi wrote:
> On Thu, 24 Sep 2009, Carlo Marcelo Arenas Belon wrote:
> 
> > Simplify userspace by eliminating the need to track whether a specific
> > filehandle was added to epoll already and only needs to be re-arm
> > after being internally disabled by EPOLLONESHOT.
> > 
> > EPOLL_CLT_SET can be used to add or modify a filehandle in epoll
> > using the kernel's internal tracking to apply the right equivalent
> > operation to EPOLL_CTL_ADD or EPOLL_CTL_MOD.
> 
> Applications (except poorly written ones) usually know what's in the 
> epoll set and what's not, in their bookkeeping.

agree, but since the kernel is also doing that bookkeeping using
ep_find it is possible by using this new operation to avoid doing
that in userspace, saving some cycles (and probably some contention in
multithreaded applications if the epoll set is global) in the hot path.

> I'm sorry, but I see no use of this code.

a very simple, probe of concept echoserver using this (once #defined)
is available from :

  http://sajino.sajinet.com.pe/echoserver.c

Carlo
