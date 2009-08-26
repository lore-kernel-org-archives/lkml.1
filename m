Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbZHZMk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbZHZMk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932843AbZHZMk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:40:27 -0400
Received: from netasq.netasq.com ([213.30.137.178]:20755 "EHLO
	netasq.netasq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbZHZMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:40:27 -0400
Date: Wed, 26 Aug 2009 14:39:31 +0200
From: Clement LECIGNE <clement.lecigne@netasq.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] 8 bytes kernel memory disclosure in AppleTalk
	getsockname.
Message-ID: <20090826123931.GA26429@clem1.netasq.com>
References: <20090826111247.GA79673@clem1.netasq.com> <4A952C2D.2010807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A952C2D.2010807@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wed, Aug 26, 2009 at 02:35:57PM +0200, Eric Dumazet wrote:
> Clement LECIGNE a écrit :
> > Hi,
> > 
> > In function atalk_getname(), sockaddr_at is returned in userland without
> > zero'ing the "char sat_zero[8]" field. This bug allows user to display 8
> > bytes leaked from the kernel stack.
> > 
> > Here is a patch that zero the whole sockaddr_at structure before
> > processing it. It should fix this bug.
> > 
> > Signed-off-by: Clément Lecigne <clement.lecigne@netasq.com>
> > --- linux/net/appletalk/ddp.c	2009-08-26 11:35:59.000000000 +0200
> > +++ linux/net/appletalk/ddp.c	2009-08-26 11:36:30.000000000 +0200
> > @@ -1241,6 +1241,8 @@ static int atalk_getname(struct socket *
> >  		if (atalk_autobind(sk) < 0)
> >  			return -ENOBUFS;
> >  
> > +	memset(&sat, 0, sizeof(struct sockaddr_at));
> > +
> >  	*uaddr_len = sizeof(struct sockaddr_at);
> >  
> >  	if (peer) {
> > 
> Hi Clement
> 
> Well, I submitted same patch some weeks ago and I just checked that
> it was already in Linus tree.
> 
> author	Eric Dumazet <eric.dumazet@gmail.com>
> 	Thu, 6 Aug 2009 02:27:43 +0000 (02:27 +0000)
> committer	David S. Miller <davem@davemloft.net>
> 	Thu, 6 Aug 2009 20:08:45 +0000 (13:08 -0700)
> commit	3d392475c873c10c10d6d96b94d092a34ebd4791
> 
> appletalk: fix atalk_getname() leak
> 
> atalk_getname() can leak 8 bytes of kernel memory to user
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 
> Dont worry, it'll be included in upcoming 2.6.31 kernel,
> and backported to previous ones as well.

Hi Eric,

Oups, shame on me, I have not checked Linus tree before submitting the
patch.

Sorry,

-- 
Clément LECIGNE,
-Only one remote hole in the default install, in more than 10 years!<br>
+Only two remote holes in the default install, in more than 10 years!<br>

