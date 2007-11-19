Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbXKSVor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbXKSVor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXKSVoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:44:39 -0500
Received: from ozlabs.org ([203.10.76.45]:56451 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbXKSVoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:44:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18242.900.101842.261763@cargo.ozlabs.ibm.com>
Date: Tue, 20 Nov 2007 08:43:32 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <20071119.050843.48408777.davem@davemloft.net>
References: <20071114.152134.266510129.davem@davemloft.net>
	<18235.40110.831730.847548@cargo.ozlabs.ibm.com>
	<20071114.172722.71465976.davem@davemloft.net>
	<20071119.050843.48408777.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> As a result I've found that perfmon2 is quite nice and allows
> incredibly useful and powerful tools to be written.  The syscalls
> aren't that bad and really I see not reason to block it's inclusion.
> 
> I rescind all of my earlier objections, let's merge this soon :-)

Strongly agree.  However, I think we need to add structure size
arguments to most of the syscalls so we can extend them later.

Also, something I've been meaning to mention to Stephane is that the
use of the cast_ulp() macro in perfmon is bogus and won't work on
32-bit big-endian platforms such as ppc32 and sparc32.  On such
platforms you can't take a pointer to an array of u64, cast it to
unsigned long * and expect the kernel bitmap operations to work
correctly on it.  At the least you also need to XOR the bit numbers
with 32 on those platforms.  Another alternative is to define the
bitmaps as arrays of bytes instead, which eliminates all byte ordering
and wordsize problems (but makes it more tricky to use the kernel
bitmap functions directly).

Paul.

