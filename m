Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0BDV43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:56:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51454
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139Ab0BDV40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:56:26 -0500
Date: Thu, 04 Feb 2010 13:56:39 -0800 (PST)
Message-Id: <20100204.135639.69720709.davem@davemloft.net>
To: penguin-kernel@I-love.SAKURA.ne.jp
Cc: opurdila@ixiacom.com, amwang@redhat.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, linux-rdma@vger.kernel.org,
       netdev@vger.kernel.org, nhorman@tuxdriver.com,
       linux-sctp@vger.kernel.org
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed
 port numbers
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002050645.CEC95380.MLOtOVFFHSFOQJ@I-love.SAKURA.ne.jp>
References: <20100204.094110.64247447.davem@davemloft.net>
	<201002042015.51092.opurdila@ixiacom.com>
	<201002050645.CEC95380.MLOtOVFFHSFOQJ@I-love.SAKURA.ne.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 5 Feb 2010 06:45:28 +0900

> Octavian Purdila wrote:
>> 
>> int inet_is_reserved_local_port(int port)
>> {
>> 	if (test_bit(port, reserved_ports))
>> 		return 1;
>> 	return 0;
>> }
>> 
> Above check is exactly what I'm doing in the LSM hook.

But his version can be done inline in 2 or 3 instructions.

An LSM hook will result in an indirect function call,
all live registers spilled to the stack, then all of
those reloaded when the function returns.

It will be much more expensive.
