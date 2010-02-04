Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab0BDQCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:02:12 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52451 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab0BDQCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:02:10 -0500
Date: Thu, 4 Feb 2010 08:02:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100204160206.GG6676@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk> <20100202065341.GF6292@linux.vnet.ibm.com> <20100203024931.GA6307@linux.vnet.ibm.com> <alpine.LFD.2.00.1002040715570.3707@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002040715570.3707@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 07:29:25AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 2 Feb 2010, Paul E. McKenney wrote:
> > 
> > One stupid question: why are the hash and length ints rather than shorts?
> > Doesn't the maximum filename length fit into a 16-bit short?  In fact,
> > doesn't the maximum length of a full pathname fit into a 16-bit short?
> 
> Yes, the name length could easily be just 16 bits. 
> 
> The hash, though, is a different matter. We actually want lots of bits to 
> spread out the dentries and 16 bits for hashing would be too small (on my 
> machine, the dentry cache hash table has half a million entries and takes 
> 4MB of space - space I'll happily give it to keep the hash chains short).
> 
> So we need at least 20 bits (and probably more on big machines).
> 
> Now, we could decide that having just 16 bits for the name hash is enough, 
> because we do mix in the address of the 'parent' dentry, and we might 
> decide that that is worth a few bits (taking the number of total bits up 
> to enough to look up half a million entries)
> 
> We could also use bitfields, and give the name length say 10 bits, and 22 
> bits to the hash, which togethr with the extra bits from the parent 
> pointer might well work out fine.
> 
> It might be worth trying. But is playing that kind of game worth four 
> extra characters in the inline name? If it were to make the difference 
> between "core dentry fields fit in a cacheline" vs "needs two cachelines", 
> then maybe it would be worth it. But I don't think that's the case.

Ah, good point on the hash size.  And given that DNAME_INLINE_LEN_MIN
is 40 characters on 32-bit systems and 32 characters on 64-bit systems,
I agree that while a four-character increase might be nice, it cannot be
said to be an emergency.

							Thanx, Paul
