Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZC2TW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZC2TW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZC2TWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:22:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbZC2TWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:22:14 -0400
Date: Sun, 29 Mar 2009 15:22:03 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix __ucmpdi2 compile bug on 32 bit builds
Message-ID: <20090329192203.GF29999@bombadil.infradead.org>
References: <20090327134252.0f24773b@osiris.boeblingen.de.ibm.com> <87prg26l79.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prg26l79.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 10:38:50AM +0100, Andi Kleen wrote:
> To be honest that sounds more like a bug in your architecture.
> 
> I don't think it's the right solution to make a new rule
> "you shall not do 64bit switch()", because that's a reasonable
> thing to do and will be hard to enforce over millions of lines
> of random Linux code.
> 
> There was a explicit decision to not support implicit 64bit 
> divides on 32bit because they're very costly, but that doesn't
> really apply to 64bit switch(). At least they shouldn't be very costly
> in theory. It seems indeed weird to call a function to compare
> a 64bit value. I bet the call sequence is larger than just 
> doing two cmps. Perhaps your gcc should be fixed? Or alternatively
> at least that function be added to the kernel runtime library.
> 

i386 will do this kind of stupidity too if you let it. I had to fix
this in nouveau a few weeks back because they were doing a u64 modulus
(a power of 2 too, no idea why gcc was so clueless as to not properly
 reduce it...)

GCC is getting much worse in this regard...

regards, Kyle
