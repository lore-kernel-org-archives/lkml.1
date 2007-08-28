Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbXH1Kj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbXH1Kj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXH1KjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:39:18 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:51182 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbXH1KjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:39:17 -0400
To: paul.moore@hp.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 15/15] LSM expansion for TOMOYO Linux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <46CED214.6050505@gmail.com>
	<46CED5F4.3030204@gmail.com>
	<200708271049.06900.paul.moore@hp.com>
In-Reply-To: <200708271049.06900.paul.moore@hp.com>
Message-Id: <200708281939.JDH33719.MVSFOOQJHFFOtL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Tue, 28 Aug 2007 19:39:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul Moore wrote:
> >    * post_recv_datagram is added in skb_recv_datagram.
>
> Can you explain to me why this is not possible using the existing 
> security_socket_sock_rcv_skb() LSM hook?

socket_sock_rcv_skb() is a hook for enqueue time.
I want a hook for dequeue time, because what TOMOYO Linux is doing is
not "whether a socket created by foo is permitted to pick up
an incoming packet from specific address/port"
but "whether bar is permitted to pick up
an incoming packet from specific address/port".
At the time of enqueue, I can't know who will pick up that packet.

Same reason for socket_post_accept(). What TOMOYO Linux is doing is
not "whether a socket created by foo is permitted to accept
a connection request from specific address/port"
but "whether bar is permitted to accept
a connection request from specific address/port".
At the time of enqueue, I can't know who will pick up that request.
