Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbXH1NWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbXH1NWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXH1NWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:22:39 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:35655 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbXH1NWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:22:38 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [TOMOYO 15/15] LSM expansion for TOMOYO Linux.
Date: Tue, 28 Aug 2007 09:21:48 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
References: <46CED214.6050505@gmail.com> <200708271049.06900.paul.moore@hp.com> <200708281939.JDH33719.MVSFOOQJHFFOtL@I-love.SAKURA.ne.jp>
In-Reply-To: <200708281939.JDH33719.MVSFOOQJHFFOtL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708280921.48867.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 28 2007 6:39:13 am Tetsuo Handa wrote:
> Hello.

Hello.

> Paul Moore wrote:
> > >    * post_recv_datagram is added in skb_recv_datagram.
> >
> > Can you explain to me why this is not possible using the existing
> > security_socket_sock_rcv_skb() LSM hook?
>
> socket_sock_rcv_skb() is a hook for enqueue time.
> I want a hook for dequeue time, because what TOMOYO Linux is doing is
> not "whether a socket created by foo is permitted to pick up
> an incoming packet from specific address/port"
> but "whether bar is permitted to pick up
> an incoming packet from specific address/port".
> At the time of enqueue, I can't know who will pick up that packet.
>
> Same reason for socket_post_accept(). What TOMOYO Linux is doing is
> not "whether a socket created by foo is permitted to accept
> a connection request from specific address/port"
> but "whether bar is permitted to accept
> a connection request from specific address/port".
> At the time of enqueue, I can't know who will pick up that request.

I apologize for not recognizing your approach from our earlier discussion on 
the LSM mailing list in July.  Unfortunately, I have the same objections to 
these changes that I did back then and from what I can recall of the 
discussion the rest of the kernel networking community agreed that these 
changes are not the preferred way of solving this problem.  We offered 
suggestions on how to accomplish your goals in a way that would be acceptable 
upstream and I would encourage you to investigate those options further.

-- 
paul moore
linux security @ hp
