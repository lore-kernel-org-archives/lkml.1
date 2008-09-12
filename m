Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYILXR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYILXR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYILXRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:17:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60895
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbYILXRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:17:17 -0400
Date: Fri, 12 Sep 2008 16:17:11 -0700 (PDT)
Message-Id: <20080912.161711.206773065.davem@davemloft.net>
To: acme@redhat.com
Cc: vegard.nossum@gmail.com, netdev@vger.kernel.org, penberg@cs.helsinki.fi,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28] tcp_ipv6: fix use of uninitialized memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080912124405.GF8935@ghostprotocols.net>
References: <20080912070525.GA22276@damson.getinternet.no>
	<20080912124405.GF8935@ghostprotocols.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Fri, 12 Sep 2008 09:44:05 -0300

> Em Fri, Sep 12, 2008 at 09:05:25AM +0200, Vegard Nossum escreveu:
> > >From 6544c4074aa5dde2e3f4d3e02f5601c1c33b770e Mon Sep 17 00:00:00 2001
> > From: Vegard Nossum <vegard.nossum@gmail.com>
> > Date: Tue, 9 Sep 2008 07:17:32 +0200
> > Subject: [PATCH] tcp_ipv6: fix use of uninitialized memory
> > 
> > inet6_rsk() is called on a struct request_sock * before we
> > have checked whether the socket is an ipv6 socket or a ipv6-
> > mapped ipv4 socket. The access that triggers this is the
> > inet_rsk(rsk)->inet6_rsk_offset dereference in inet6_rsk().
> > 
> > This is arguably not a critical error as the inet6_rsk_offset
> > is only used to compute a pointer which is never really used
> > (in the code path in question) anyway. But it might be a
> > latent error, so let's fix it.
> > 
> > Spotted by kmemcheck.
> 
> Humm, so this was poisoned at allocation and then when inet6_rsk_offset
> was accessed it noticed, interesting, thanks!
> 
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Good find :)  I'll add this to net-next-2.6, thanks!
