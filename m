Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYDUUkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYDUUkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYDUUjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:39:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49729
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752750AbYDUUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:39:38 -0400
Date: Mon, 21 Apr 2008 13:39:40 -0700 (PDT)
Message-Id: <20080421.133940.52972455.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, paulmck@us.ibm.com, jirislaby@gmail.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
	<200804211812.16994.rjw@sisk.pl>
	<alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Apr 2008 09:54:07 -0700 (PDT)

> What I find interesting is that at least for me, I have the SLAB bucket 
> size for nf_conntrack_expect being 208 bytes. And the *biggest* merge by 
> far after 2.6.25 so far has been networking (and conntrack in particular)
> 
> Is that a smoking gun? Not necessarily. But it *is* intriguing. But there 
> are other possible clashes (the 192-byte bucket has several different 
> suspects, and not all of them are in networking).1

I think you might be onto something here.

The "mask" member of struct nf_conntrack_expect could be reasonably
all 1's like the value reported in the crash that begins this
thread.

Do we know the offset within the object at which this all 1's
value is found?

My rough calculations show that on 32-bit that expect->mask member is
at offset 56 and on 64-bit it should be at offset 72.  Does that
match up to the offset of the filp or whatever bit being corrupted?

I'll scan through the netfilter changesets in post 2.6.25 to see if
anything stands out.


