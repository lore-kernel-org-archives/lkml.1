Return-Path: <linux-kernel-owner+w=401wt.eu-S966068AbXCTCib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966068AbXCTCib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 22:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965795AbXCTCib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 22:38:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34732
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965796AbXCTCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 22:38:30 -0400
Date: Mon, 19 Mar 2007 19:38:29 -0700 (PDT)
Message-Id: <20070319.193829.102575512.davem@davemloft.net>
To: bunk@stusta.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org, netdev@vger.kernel.org
Subject: Re: [6/6] 2.6.21-rc4: known regressions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070318184938.GZ752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070318184938.GZ752@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Sun, 18 Mar 2007 19:49:38 +0100

> Subject    : ipv6 crash
> References : http://lkml.org/lkml/2007/3/10/2
> Submitter  : Len Brown <lenb@kernel.org>
> Status     : unknown

This is caused by some problem in the router round-robin code in
net/ipv6/route.c:rt6_select()

Somehow it NULLs out fn->leaf, and then fib6_add_1() crashes
dererencing that NULL pointer as is seen in the report.

Deleting the router round-robin list mangling code in rt6_select()
makes the crash go away, but such a change causes regressions in the
ipv6 conformance tests.

Thomas Graf discovered this bug some time ago, but we still
haven't come up with a fix suitable for upstream :-/

This bug has been there for a very long time and is not a regression
of 2.6.21

I'll see if I can come up with something to fix this properly.
