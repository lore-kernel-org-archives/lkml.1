Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbZLVAOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbZLVAOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZLVAOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:14:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57797 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZLVAOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:14:04 -0500
Date: Tue, 22 Dec 2009 01:13:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, rguenther@suse.de,
       arnd@arndb.de
Subject: Re: [PATCH] Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with
	gcc 4.5 snapshot
Message-ID: <20091222001357.GJ25372@basil.fritz.box>
References: <20091220165315.GA13208@basil.fritz.box> <200912212102.39878.rusty@rustcorp.com.au> <20091221105138.GD25372@basil.fritz.box> <200912221014.02545.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912221014.02545.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, it's solving the same problem, generically.  There are numerous places
> where we want to use BUILD_BUG_ON() but we don't have a constant expression.
> Look for MAYBE_BUILD_BUG_ON().

Ok so you're saying that should be just a MAYBE_BUILD_BUG_ON()? 

> 
> Subject: BUILD_BUG_ON: make it handle more cases
> 
> BUILD_BUG_ON used to use the optimizer to do code elimination or fail
> at link time; it was changed to first the size of a negative array (a
> nicer compile time error), then (in
> 8c87df457cb58fe75b9b893007917cf8095660a0) to a bitfield.
> 
> bitfields: needs a literal constant at parse time, and can't be put under
> 	"if (__builtin_constant_p(x))" for example.
> negative array: can handle anything, but if the compiler can't tell it's
> 	a constant, silently has no effect.
> link time: breaks link if the compiler can't determine the value, but the
> 	linker output is not usually as informative as a compiler error.
> 
> If we use the negative-array-size method *and* the link time trick,
> we get the ability to use BUILD_BUG_ON() under __builtin_constant_p()
> branches, and maximal ability for the compiler to detect errors at
> build time.

Ok maybe that works, but we need a fix for 2.6.33 too.

-Andi

