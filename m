Return-Path: <linux-kernel-owner+w=401wt.eu-S932834Ab0AGDyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab0AGDyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602Ab0AGDyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:54:19 -0500
Received: from waste.org ([173.11.57.241]:46176 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594Ab0AGDyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:54:18 -0500
Subject: Re: [PATCH] netpoll: allow execution of multiple rx_hooks per
 interface
From: Matt Mackall <mpm@selenic.com>
To: Daniel Borkmann <danborkmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
       netdev@vger.kernel.org, netdev@oss.sgi.com,
       David Miller <davem@davemloft.net>
In-Reply-To: <4B44F895.9080205@gmail.com>
References: <4B44F895.9080205@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 21:54:05 -0600
Message-ID: <1262836445.29868.227.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 21:54 +0100, Daniel Borkmann wrote:
> Hi,
> 
> this patch allows the registration and _execution_ of multiple netpoll
> rx_hooks per interface. Currently, it is possible to register multiple
> netpoll structures to one interface, _but_ only one single rx_hook (from
> the netpoll struct that has been registered last) can be executed, which
> was an oversight in the implementation [1].
> So, this patch fixes it. I've sucessfully tested it within 2.6.32.2 with
> the registration of multiple rx_hook clients for several times. I'd
> appreciate comments / feedback.

(grumbles about cc:)

Please inline patches so they can be reviewed easily in reply.


-       struct netpoll *np = npi->rx_np;
+       struct netpoll **np = &npi->rx_np;
 
-       if (!np)
+       if (!(*np))

This makes everything horrible. Can you avoid the double indirection?
Using a list head might be a good answer.

-- 
http://selenic.com : development and support for Mercurial and Linux


