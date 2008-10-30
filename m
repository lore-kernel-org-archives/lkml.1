Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbYJ3RBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbYJ3RBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYJ3RBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:01:45 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:18516 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbYJ3RBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J4GU2KB0PT3lr3qfYdQSNM2SZcK/RHct1dEINMCH9TkbSBMdmdnPKRt3UdgzTKSCJz
         yjNfzVTke3Z8dkGTicM0u3+qa84WrMRccTl542aTPeJqqnmVWxt4QXkQiWzn4X9tXF/p
         UM2spxPISPSU1X/ADj3jvFFIJJHBRHktK87L4=
Message-ID: <7a6abd110810301001r7fc311adifd85fece79cb5c45@mail.gmail.com>
Date: Thu, 30 Oct 2008 18:01:42 +0100
From: "Jonas Bonn" <jonas.bonn@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] API for system clocks (oscillators)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9e4733910810300939x40a7afear7a49557604ced628@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
	 <9e4733910810300840v7cd45c2cu629d23a27a02c61a@mail.gmail.com>
	 <7a6abd110810300927l428b11f3u509ad31364c08f1f@mail.gmail.com>
	 <9e4733910810300939x40a7afear7a49557604ced628@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> You could probably work those features into the existing clk framework.
> clk_set_rate() could compute the constrains and return an error.
> The API could be expanded with notifier support.
>

I started in this end, too, and got frequency change notification
working, at least.  There are issues with mutexes that "might_sleep"
when calling set_rate from cpuidle driver, but nothing that can't be
fixed...

What drove me to document a new interface is the fact that there are
so many users of "struct clk" already, that it becomes conceptually
easier to dream up something new that stays out of the way, even if
that new  thing becomes just a wrapper around the existing interface
(which I am well aware that it largely is) with some new
functionality.  If we can bolt the new stuff onto the existing stuff,
then that's even better; however, I know that yesterday I was longing
to be able to start from scratch and "do it right"!  After writing my
document, though, I think I have largely validated the model that's in
place...

That said, I still think there is value in the additional features.

/Jonas
