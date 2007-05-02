Return-Path: <linux-kernel-owner+w=401wt.eu-S1766840AbXEBRRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766840AbXEBRRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766842AbXEBRRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:17:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51779 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766840AbXEBRRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:17:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
References: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com>
	<20070502005140.b94500ff.akpm@linux-foundation.org>
	<20070502084617.GY26598@holomorphy.com>
	<20070502100600.GZ26598@holomorphy.com> <4638BC3E.9080708@goop.org>
	<20070502163244.GA26598@holomorphy.com>
Date: Wed, 02 May 2007 11:16:27 -0600
In-Reply-To: <20070502163244.GA26598@holomorphy.com> (Bill Irwin's message of
	"Wed, 2 May 2007 09:32:44 -0700")
Message-ID: <m1k5vrw3h0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin <bill.irwin@oracle.com> writes:

> Bill Irwin wrote:
>>> Brain dump before crashing for the night:
>>> The patch refuses to clobber already-present pagetable entries of
>>> whatever origin. There are pagetables prior to this setup covering the
>>> address range just above PAGE_OFFSET. If this theory is correct, you
>>> should only be able to go a few MB above PAGE_OFFSET before encountering
>>> unreadable kernel memory. IIRC those pagetables are a statically
>>> allocated array in assembly; altering that array to set supervisor bits
>>> may resolve it, though it may also be freed as initmem.
>
> On Wed, May 02, 2007 at 09:28:46AM -0700, Jeremy Fitzhardinge wrote:
>> I think this should be fixed now.  Eric made all those writes
>> unconditional (to fix a problem with PSE superpages not being created). 
>> The patch is in Andi's queue.
>
> It needs verification with the testcase from this thread.

Sounds reasonable.

However there is no reason to suspect it won't fix this case because
unconditional writes are what we have always done, and we have always
kept swapper_pg_dir from early boot as well.

In essence my patch I sent out to Andi was a partial revert.

It isn't slated to go in until nextround but I also rewrote the early
page table setup in C.  Allowing set_fixmap to work in the early
kernel, and fix problems of not having enough memory mapped to build
the identity mappings, because we are then updating the page table
we have also in the PAE case.

Eric
