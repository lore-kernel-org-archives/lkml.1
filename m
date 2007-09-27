Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbXI0TBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbXI0TBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbXI0TBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:01:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54258
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756567AbXI0TBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:01:14 -0400
Date: Thu, 27 Sep 2007 12:01:14 -0700 (PDT)
Message-Id: <20070927.120114.95884344.davem@davemloft.net>
To: helge.hafting@aitel.hist.no
Cc: shemminger@linux-foundation.org, jengelh@computergmbh.de,
       olecom@flower.upol.cz, jbeulich@novell.com,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: why network devices don't do reference counting?
From: David Miller <davem@davemloft.net>
In-Reply-To: <46FB99EF.4020806@aitel.hist.no>
References: <Pine.LNX.4.64.0709270017120.17414@fbirervta.pbzchgretzou.qr>
	<20070926153330.77aade4d@freepuppy.rosehill>
	<46FB99EF.4020806@aitel.hist.no>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Helge Hafting <helge.hafting@aitel.hist.no>
Date: Thu, 27 Sep 2007 13:54:23 +0200

> Wouldn't it be enough to down all the interfaces and close all the sockets?
> No need to bring down every app.

And there are routes, and neighbour cache entries, and all sorts
of external references to the stack.  For example, if a packet
gets stuck in a device because the link just went down, that
can hold references to the ipv6 module from several angles.

But you have to add code to actually keep track of all of these
references and there is no such code in the ipv6 module at all
and it's a nontrivial time consuming job to implement it.
