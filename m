Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668Ab0BEBIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:08:48 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:30064 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933649Ab0BEBIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:08:46 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Date: Fri, 5 Feb 2010 03:05:22 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-trunk-686; KDE/4.3.2; i686; ; )
Cc: davem@davemloft.net, amwang@redhat.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, linux-rdma@vger.kernel.org,
       netdev@vger.kernel.org, nhorman@tuxdriver.com,
       linux-sctp@vger.kernel.org
References: <20100204.094110.64247447.davem@davemloft.net> <20100204.135639.69720709.davem@davemloft.net> <201002050041.o150fCO8081208@www262.sakura.ne.jp>
In-Reply-To: <201002050041.o150fCO8081208@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002050305.22227.opurdila@ixiacom.com>
X-OriginalArrivalTime: 05 Feb 2010 01:08:44.0192 (UTC) FILETIME=[C3190200:01CAA5FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 February 2010 02:41:12 you wrote:
> David Miller wrote:
> > > Octavian Purdila wrote:
> > >> int inet_is_reserved_local_port(int port)
> > >> {
> > >> 	if (test_bit(port, reserved_ports))
> > >> 		return 1;
> > >> 	return 0;
> > >> }
> > >
> > > Above check is exactly what I'm doing in the LSM hook.
> >
> > But his version can be done inline in 2 or 3 instructions.
> >
> > An LSM hook will result in an indirect function call,
> > all live registers spilled to the stack, then all of
> > those reloaded when the function returns.
> >
> > It will be much more expensive.
> 
> If you can accept his version, I want to use his version (with an interface
>  for updating above "reserved_ports" by not only root user's sysctl() but
>  also MAC's policy configuration).
> 

I think that simply using an interface to update the reserved_ports from MAC 
policy configuration module wouldn't work, as root will be able to modify the 
policy via sysctl.

I think that we might need to:

a) have a reserved_port updater

b) put a LSM hook into that

c) use the reserved_port updater from sysctl



