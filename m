Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYHSEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYHSEST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYHSESK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:18:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbYHSESJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:18:09 -0400
Date: Mon, 18 Aug 2008 21:17:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anthony Liguori <aliguori@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Avi Kivity <avi@qumranet.com>,
       virtualization@lists.linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] virtio_balloon: fix towards_target when deflating
 balloon
In-Reply-To: <48AA1D5E.5050405@us.ibm.com>
Message-ID: <alpine.LFD.1.10.0808182115210.3324@nehalem.linux-foundation.org>
References: <1219097731-1224-1-git-send-email-aliguori@us.ibm.com> <alpine.LFD.1.10.0808181740500.3324@nehalem.linux-foundation.org> <48AA1D5E.5050405@us.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Aug 2008, Anthony Liguori wrote:
> 
> Nothing.  It works just fine.  However, I implemented it more verbosely
> because this is the second time we've "fixed" this problem.  See
> 
> commit bdc1681cdf1ab6a65fa935a2b3f8fc63b20c54ea
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Mon Mar 17 22:58:15 2008 -0500
> 
>    virtio: handle > 2 billion page balloon targets

Well, we could perhaps add a sparse warning that makes noise when a 
unsigned subtraction is cast to a wider signed field. I dunno if it would 
catch anything interesting, or just cause a ton of irritating noise.

> So I thought I'd rely a little less on the subtleties of promotion and make
> things a bit more clear.  However, I don't feel that strongly about it so here
> you go.

Ugly and inefficient is not acceptable, even for these kinds of reasons. 
So yes, the simpler version is much better.

		Linus
