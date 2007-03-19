Return-Path: <linux-kernel-owner+w=401wt.eu-S965678AbXCSGNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965678AbXCSGNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 02:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965673AbXCSGNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 02:13:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60084
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965671AbXCSGNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 02:13:16 -0400
Date: Sun, 18 Mar 2007 23:13:16 -0700 (PDT)
Message-Id: <20070318.231316.59470365.davem@davemloft.net>
To: ebiederman@lnxi.com
Cc: mst@dev.mellanox.co.il, kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3aby94x6o.fsf@maxwell.lnxi.com>
References: <20070318224234.GP11078@mellanox.co.il>
	<20070318.171337.112622504.davem@davemloft.net>
	<m3aby94x6o.fsf@maxwell.lnxi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederman@lnxi.com (Eric W. Biederman)
Date: Sun, 18 Mar 2007 23:30:39 -0600

> Sure.  In the network namespace case I think the careful ordering of the
> shutdown handles that case.   Even with per network namespace lo
> unregistered it still existed until the network namespace actually
> exited.  And it only happened on exit.  
> 
> So while there may be a tiny race there it hasn't been an issue yet
> in practice.

I think the thing to do is to just leave the loopback references
in place, try to unregister the per-namespace loopback device,
and that will safely wait for all the references to go away.

If you do it that way, you should need absolutely no changes to
the other code in this area.

As per Herbert, I think he works on Xen rather than vserver :-)
Perhaps you're thinking of Alexey Kuznetsov or another one of the
vserver guys.
