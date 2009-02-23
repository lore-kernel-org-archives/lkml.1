Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbZBWIY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbZBWIY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZBWIYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:24:42 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:62946 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbZBWIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=trxObCRX5MGuK5c7Us7DTtIZvEemxm1jj439h9mLvj6ys9Gyekb+ZBkwK54R0U4IfJ
         0sZESFRuPZ/TDi5ybsKmRxvKlPGfuiQvA9GwpiEZ1OdPkIkTovN89Oa4+Do3FnRfDP7D
         ufjHhcB5GUrwuGxqdFdK6Iefwgk9eqRqsh7n0=
MIME-Version: 1.0
In-Reply-To: <20090223051709.GA5990@linux.vnet.ibm.com>
References: <20090220140157.GA12799@elte.hu>
	 <20090220154619.GC6960@linux.vnet.ibm.com>
	 <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com>
	 <20090221014056.GU6960@linux.vnet.ibm.com>
	 <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com>
	 <20090221174703.GA6860@linux.vnet.ibm.com>
	 <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com>
	 <19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com>
	 <20090222030030.GD6860@linux.vnet.ibm.com>
	 <20090223051709.GA5990@linux.vnet.ibm.com>
Date: Mon, 23 Feb 2009 09:24:39 +0100
Message-ID: <19f34abd0902230024g63aadad2jef16c97a9d792291@mail.gmail.com>
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/23 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> Hello, Vegard,
>
> Could you please try out the following patch?  I am not 100% confident
> of it on non-x86 architectures, nor during the time that non-boot CPUs
> start up (though this patch should not break non-boot CPUs any more than
> they might already be broken).

Hi!

This patch fixes it for me. Now I see the huge stream of call_rcu()s,
followed by a huge stream of kfrees() (after the list traversal has
completed).


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
