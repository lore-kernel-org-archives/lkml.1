Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbXGJDaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbXGJDaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXGJD3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:29:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48660
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754368AbXGJD3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:29:38 -0400
Date: Mon, 09 Jul 2007 15:22:52 -0700 (PDT)
Message-Id: <20070709.152252.13771404.davem@davemloft.net>
To: ssatyam@cse.iitk.ac.in
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -rc7 1/1] netpoll: Fix a leak-n-bug in netpoll_cleanup()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070704110641.28497.92035.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070704110641.28497.92035.sendpatchset@cselinux1.cse.iitk.ac.in>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Date: Wed, 04 Jul 2007 16:36:41 +0530

> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [1/1] netpoll: Fix a leak-n-bug in netpoll_cleanup()
> 
> 93ec2c723e3f8a216dde2899aeb85c648672bc6b applied excessive duct tape to
> the netpoll beast's netpoll_cleanup(), thus substituting one leak with
> another, and opening up a little buglet :-)
> 
> net_device->npinfo (netpoll_info) is a shared and refcounted object and
> cannot simply be set NULL the first time netpoll_cleanup() is called.
> Otherwise, further netpoll_cleanup()'s see np->dev->npinfo == NULL and
> become no-ops, thus leaking. And it's a bug too: the first call to
> netpoll_cleanup() would thus (annoyingly) "disable" other (still alive)
> netpolls too. Maybe nobody noticed this because netconsole (only user
> of netpoll) never supported multiple netpoll objects earlier.
> 
> This is a trivial and obvious one-line fixlet.
> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Applied to net-2.6.23, I'll forward this on to -stable too.

Thanks.
