Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab0BEAlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 19:41:16 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:54778 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab0BEAlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 19:41:15 -0500
Message-Id: <201002050041.o150fCO8081208@www262.sakura.ne.jp>
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: davem@davemloft.net
Cc: opurdila@ixiacom.com, amwang@redhat.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, linux-rdma@vger.kernel.org,
       netdev@vger.kernel.org, nhorman@tuxdriver.com,
       linux-sctp@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Feb 2010 09:41:12 +0900
References: <20100204.094110.64247447.davem@davemloft.net> <201002042015.51092.opurdila@ixiacom.com> <201002050645.CEC95380.MLOtOVFFHSFOQJ@I-love.SAKURA.ne.jp> <20100204.135639.69720709.davem@davemloft.net>
In-Reply-To: <20100204.135639.69720709.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05022010 #3193673, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> > Octavian Purdila wrote:
> >> 
> >> int inet_is_reserved_local_port(int port)
> >> {
> >> 	if (test_bit(port, reserved_ports))
> >> 		return 1;
> >> 	return 0;
> >> }
> >> 
> > Above check is exactly what I'm doing in the LSM hook.
> 
> But his version can be done inline in 2 or 3 instructions.
> 
> An LSM hook will result in an indirect function call,
> all live registers spilled to the stack, then all of
> those reloaded when the function returns.
> 
> It will be much more expensive.

If you can accept his version, I want to use his version (with an interface for
updating above "reserved_ports" by not only root user's sysctl() but also MAC's
policy configuration).
