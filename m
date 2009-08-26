Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbZHZMf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbZHZMf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbZHZMf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:35:58 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37803 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697AbZHZMf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:35:58 -0400
Message-ID: <4A952C2D.2010807@gmail.com>
Date: Wed, 26 Aug 2009 14:35:57 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Clement LECIGNE <clement.lecigne@netasq.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] 8 bytes kernel memory disclosure in AppleTalk getsockname.
References: <20090826111247.GA79673@clem1.netasq.com>
In-Reply-To: <20090826111247.GA79673@clem1.netasq.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 26 Aug 2009 14:35:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clement LECIGNE a écrit :
> Hi,
> 
> In function atalk_getname(), sockaddr_at is returned in userland without
> zero'ing the "char sat_zero[8]" field. This bug allows user to display 8
> bytes leaked from the kernel stack.
> 
> Here is a patch that zero the whole sockaddr_at structure before
> processing it. It should fix this bug.
> 
> Signed-off-by: Clément Lecigne <clement.lecigne@netasq.com>
> --- linux/net/appletalk/ddp.c	2009-08-26 11:35:59.000000000 +0200
> +++ linux/net/appletalk/ddp.c	2009-08-26 11:36:30.000000000 +0200
> @@ -1241,6 +1241,8 @@ static int atalk_getname(struct socket *
>  		if (atalk_autobind(sk) < 0)
>  			return -ENOBUFS;
>  
> +	memset(&sat, 0, sizeof(struct sockaddr_at));
> +
>  	*uaddr_len = sizeof(struct sockaddr_at);
>  
>  	if (peer) {
> 
Hi Clement

Well, I submitted same patch some weeks ago and I just checked that
it was already in Linus tree.

author	Eric Dumazet <eric.dumazet@gmail.com>
	Thu, 6 Aug 2009 02:27:43 +0000 (02:27 +0000)
committer	David S. Miller <davem@davemloft.net>
	Thu, 6 Aug 2009 20:08:45 +0000 (13:08 -0700)
commit	3d392475c873c10c10d6d96b94d092a34ebd4791

appletalk: fix atalk_getname() leak

atalk_getname() can leak 8 bytes of kernel memory to user

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>


Dont worry, it'll be included in upcoming 2.6.31 kernel,
and backported to previous ones as well.
