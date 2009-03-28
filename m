Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZC1JjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZC1JjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZC1Ji4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:38:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48314 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZC1Jiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:38:55 -0400
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix __ucmpdi2 compile bug on 32 bit builds
From: Andi Kleen <andi@firstfloor.org>
References: <20090327134252.0f24773b@osiris.boeblingen.de.ibm.com>
Date: Sat, 28 Mar 2009 10:38:50 +0100
In-Reply-To: <20090327134252.0f24773b@osiris.boeblingen.de.ibm.com> (Heiko Carstens's message of "Fri, 27 Mar 2009 13:42:52 +0100")
Message-ID: <87prg26l79.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens <heiko.carstens@de.ibm.com> writes:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> We get this on 32 builds:
>
> fs/built-in.o: In function `extent_fiemap':
> (.text+0x1019f2): undefined reference to `__ucmpdi2'

>
> Happens because of a switch statement with a 64 bit argument.
> Convert this to an if statement to fix this.


To be honest that sounds more like a bug in your architecture.

I don't think it's the right solution to make a new rule
"you shall not do 64bit switch()", because that's a reasonable
thing to do and will be hard to enforce over millions of lines
of random Linux code.

There was a explicit decision to not support implicit 64bit 
divides on 32bit because they're very costly, but that doesn't
really apply to 64bit switch(). At least they shouldn't be very costly
in theory. It seems indeed weird to call a function to compare
a 64bit value. I bet the call sequence is larger than just 
doing two cmps. Perhaps your gcc should be fixed? Or alternatively
at least that function be added to the kernel runtime library.

-Andi


ak@linux.intel.com -- Speaking for myself only.
