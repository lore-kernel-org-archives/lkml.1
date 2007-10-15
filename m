Return-Path: <linux-kernel-owner+w=401wt.eu-S1765441AbXJOREB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765441AbXJOREB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXJORDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:03:30 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:39049 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbXJORD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:03:27 -0400
Date: Mon, 15 Oct 2007 18:03:20 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jarek Poplawski <jarkao2@o2.pl>
cc: Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
In-Reply-To: <20071015125301.GC3015@ff.dom.local>
Message-ID: <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl>
References: <20071015125301.GC3015@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Jarek Poplawski wrote:

> Could you explain why cancel_work_sync() is better here than
> flush_scheduled_work() wrt. rtnl_lock()?

 Well, this is actually the bit that made cancel_work_sync() be written in 
the first place.  The short story is the netlink lock is most probably 
held at this point (depending on the usage of phy_disconnect()) and there 
is also an event waiting in the queue that requires the lock, so if 
flush_scheduled_work() is called here a deadlock will happen.

 Let me find a reference for a longer story...:

http://www.linux-mips.org/cgi-bin/mesg.cgi?a=linux-mips&i=Pine.LNX.4.64N.0610031509380.4642%40blysk.ds.pg.gda.pl

and then discussed again:

http://www.uwsg.indiana.edu/hypermail/linux/kernel/0612.0/0593.html

  Maciej
