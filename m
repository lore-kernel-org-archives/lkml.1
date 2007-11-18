Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbXKRAD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbXKRAD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 19:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXKRADU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 19:03:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42309
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753945AbXKRADT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 19:03:19 -0500
Date: Sat, 17 Nov 2007 16:03:16 -0800 (PST)
Message-Id: <20071117.160316.162501140.davem@davemloft.net>
To: andi@firstfloor.org
Cc: arjan@infradead.org, dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
       netdev@vget.kernel.org
Subject: Re: [NET]: rt_check_expire() can take a long time, add a
 cond_resched()
From: David Miller <davem@davemloft.net>
In-Reply-To: <p73k5ohav4n.fsf@bingen.suse.de>
References: <473D18A5.2090309@cosmosbay.com>
	<20071115215938.44233733@laptopd505.fenrus.org>
	<p73k5ohav4n.fsf@bingen.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Sat, 17 Nov 2007 13:56:08 +0100

> Arjan van de Ven <arjan@infradead.org> writes:
> >> > 
> >> > Its not that cheap. The ChangeLog included my own numbers, on a
> >> > Pentium M machine. (i686, 1.6 GHz, 1.5 GB ram)
> >> > 
> >> > Without "if (need_resched())" (so calling need_resched() X.XXX.XXX 
> >> > times), each run takes 88ms
> >> > 
> >> > With the extra check (and *much* less function calls), each run
> >> > takes 25ms
> 
> ms?!? The numbers sound wrong. Wrong unit? 

Read what Eric is saying.  He is saying "any entire run" purging
the routing cache takes that long, not just one call.
