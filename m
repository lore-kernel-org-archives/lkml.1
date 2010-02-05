Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab0BEJIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:08:25 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:62452 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab0BEJIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:08:22 -0500
To: bvanassche@acm.org
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
       nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, davem@davemloft.net
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed portnumbers
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain>
	<e2e108261002042311w59ba1372ld9f8fb2f369ca434@mail.gmail.com>
	<4B6BC7E4.5070909@redhat.com>
In-Reply-To: <4B6BC7E4.5070909@redhat.com>
Message-Id: <201002051808.BFJ51557.SLQFtJVMOOFFOH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 5 Feb 2010 18:08:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang wrote:
> The problem is that there are some existing applications which use
> fixed port number, we don't have chances to change this for them,
> thus making them working is desired, so they want to reserve these
> port for those applications.
> 
> For example, if I have an appliction which uses port 40000, but
> before this application starts, another application gets this port
> number by bind() with port 0 (i.e. chosen by kernel), in this case,
> that application will fail to start. Again, we don't have any chance
> to change the source code of that application.
> 
And there is a utility called "portreserved" (port reserve daemon).
http://fedoraproject.org/wiki/Features/Portreserve

But that utility cannot close the race window between "portreserved stops
reserving local port numbers" and "applications starts using local port
numbers which portreserved was reserving".

Thus, I think people want to have port reservation mechanism inside kernel
(if it has little impact).
