Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab0CJPdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:33:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41018
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756690Ab0CJPdI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:33:08 -0500
Date: Wed, 10 Mar 2010 07:33:28 -0800 (PST)
Message-Id: <20100310.073328.141230852.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: penguin-kernel@I-love.SAKURA.ne.jp, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       shemminger@vyatta.com
Subject: Re: [2.6.34-rc1] CPU stalls when closing TCP sockets.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268150156.3113.12.camel@edumazet-laptop>
References: <1268116647.2819.64.camel@edumazet-laptop>
	<201003090654.o296sCnh065487@www262.sakura.ne.jp>
	<1268150156.3113.12.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 09 Mar 2010 16:55:56 +0100

> Le mardi 09 mars 2010 à 15:54 +0900, Tetsuo Handa a écrit :
>> Eric Dumazet wrote:
>> > Nothing comes to my mind, I'll try to reproduce this here.
>> 
>> When stopped at (8), Ctrl-C doesn't work.
>> 
>> > Is 2.6.33 OK ?
>> 
>> Yes. 2.6.33 and earlier are OK.
> 
> OK thanks !
> 
> I believe commit d218d11133d888f9745802146a50255a4781d37a
> (tcp: Generalized TTL Security Mechanism) might be the bug origin.
> 
> I am testing following patch, based on latest net-2.6 tree (including
> the LINUX_MIB_TCPMINTTLDROP bit)
> 
> [PATCH] tcp: Fix tcp_v4_rcv()
> 
> Commit d218d111 (tcp: Generalized TTL Security Mechanism) added a bug
> for TIMEWAIT sockets. We should not test min_ttl for TW sockets.
> 
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks everyone.
