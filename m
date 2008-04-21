Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYDUVyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYDUVyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYDUVyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:54:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60338
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbYDUVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:54:38 -0400
Date: Mon, 21 Apr 2008 14:54:39 -0700 (PDT)
Message-Id: <20080421.145439.174096017.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, paulmck@us.ibm.com, jirislaby@gmail.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804211407370.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
	<20080421.133940.52972455.davem@davemloft.net>
	<alpine.LFD.1.10.0804211407370.2779@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Apr 2008 14:19:26 -0700 (PDT)

> However, the Code: line for one of the oopses shows that in that 
> particular case, it was at offset 0x18 (ie the normal 24), so at least one 
> of the oopses had no such thing going on.

On 64-bit x86_64, which I believe the case you are referring to
is, that would be right in the middle of an hlist_node.

We would expect to see a valid pointer, NULL, or a list poison
value.  Which we're not.

But I don't think networking or even netfilter can in any way be ruled
out yet.

A lot of the speculation is because of the SLUB cache sharing between
different object types.  Is there some way to disable that and see how
that influences the bug?

Of course, even with sharing disabled a cache's page could get freed
and then re-allocated into another cache, but the likelyhood of it
happening exactly to a filp or dentry cache from a netfilter or whatever
one is extremely unlikely :)

