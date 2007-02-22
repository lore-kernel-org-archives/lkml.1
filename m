Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbXBVNkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbXBVNkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXBVNkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:40:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48428
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbXBVNkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:40:14 -0500
Date: Thu, 22 Feb 2007 05:40:12 -0800 (PST)
Message-Id: <20070222.054012.71091934.davem@davemloft.net>
To: linux@horizon.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070222122721.12459.qmail@science.horizon.com>
References: <20070222122721.12459.qmail@science.horizon.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: linux@horizon.com
Date: 22 Feb 2007 07:27:21 -0500

> May I just say, that this is f***ing brilliant.

It's brilliant for disk I/O, not for networking for which
blocking is the norm not the exception.

So people will have to likely do something like divide their
applications into handling for I/O to files and I/O to networking.
So beautiful. :-)

Nobody has proposed anything yet which scales well and handles both
cases.

It is one reoccuring point made by Evgeniy, and he is very right
about it.

If used for networking one could easily make this new interface create
an arbitrary number of threads by just opening up that many
connections to such a server and just sitting there not reading
anything from any of the client sockets.  And this happens
non-maliciously for slow clients, whether that is due to application
blockage or the characteristics of the network path.
