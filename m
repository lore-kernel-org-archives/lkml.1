Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbXEBKGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbXEBKGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbXEBKGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:06:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31280 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbXEBKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:06:20 -0400
Date: Wed, 2 May 2007 03:06:00 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bill Irwin <bill.irwin@oracle.com>, Dan Kruchinin <dubalom@gmail.com>,
       linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, wli@holomorphy.com
Subject: Re: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
Message-ID: <20070502100600.GZ26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
	Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
	Ingo Molnar <mingo@elte.hu>
References: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com> <20070502005140.b94500ff.akpm@linux-foundation.org> <20070502084617.GY26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502084617.GY26598@holomorphy.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 12:51:40AM -0700, Andrew Morton wrote:
>> Thanks for the report.  I can reproduce it.
>> Bisection shows that x86_64-mm-paravirt-initial-pagetable.patch caused
>> this.
>> I didn't check whether the patch actually permits us to read kernel
>> memory.  Probably it does.  Probably we'd prefer that it didn't ;)

On Wed, May 02, 2007 at 01:46:17AM -0700, Bill Irwin wrote:
> Brown paper bag time. I don't know how it got past me.

Brain dump before crashing for the night:

The patch refuses to clobber already-present pagetable entries of
whatever origin. There are pagetables prior to this setup covering the
address range just above PAGE_OFFSET. If this theory is correct, you
should only be able to go a few MB above PAGE_OFFSET before encountering
unreadable kernel memory. IIRC those pagetables are a statically
allocated array in assembly; altering that array to set supervisor bits
may resolve it, though it may also be freed as initmem.


-- wli
