Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbXICNPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbXICNPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXICNPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:15:23 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49829 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbXICNPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:15:22 -0400
To: paul.moore@hp.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 15/15] LSM expansion for TOMOYO Linux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <46CED214.6050505@gmail.com>
	<200708271049.06900.paul.moore@hp.com>
	<200708281939.JDH33719.MVSFOOQJHFFOtL@I-love.SAKURA.ne.jp>
	<200708280921.48867.paul.moore@hp.com>
In-Reply-To: <200708280921.48867.paul.moore@hp.com>
Message-Id: <200709032215.DCF36819.SLQtHFMFOOFOVJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Mon, 3 Sep 2007 22:15:27 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul Moore wrote:
> I apologize for not recognizing your approach from our earlier discussion on 
> the LSM mailing list in July.  Unfortunately, I have the same objections to 
> these changes that I did back then and from what I can recall of the 
> discussion the rest of the kernel networking community agreed that these 
> changes are not the preferred way of solving this problem.  We offered 
> suggestions on how to accomplish your goals in a way that would be acceptable 
> upstream and I would encourage you to investigate those options further.

When I proposed a patch in July, I was patching at post-copy_to_user() step
(i.e. after sock_recvmsg()).
This approach messed up user-supplied buffer.

This time, I'm patching at pre-copy_to_user() step
(i.e. at skb_recv_datagram()).
This approach doesn't mess up user-supplied buffer.
I think this is a cleaner way than the previous patch.

Although read() gets an error when select() said "read ready",
I can't find other place to use for accomplishing my goals.

By the way, similar thing can happen when select() against
a file descriptor said "read ready" but read() gets an error
if security policy or security-id of the file has changed
between select() and read(), isn't it?
And such behavior is acceptable, isn't it?
If such behavior can happen and is acceptable and *preferable*,
I think checking permission at dequeue time (i.e. skb_recv_datagram())
is *preferable* way than checking permission at enqueue time
(i.e. socket_sock_rcv_skb()).

Regards.
