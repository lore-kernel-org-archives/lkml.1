Return-Path: <linux-kernel-owner+w=401wt.eu-S2993491AbXEBQ3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993491AbXEBQ3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993492AbXEBQ3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:29:42 -0400
Received: from gw.goop.org ([64.81.55.164]:43388 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993491AbXEBQ3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:29:41 -0400
Message-ID: <4638BC3E.9080708@goop.org>
Date: Wed, 02 May 2007 09:28:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
References: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com> <20070502005140.b94500ff.akpm@linux-foundation.org> <20070502084617.GY26598@holomorphy.com> <20070502100600.GZ26598@holomorphy.com>
In-Reply-To: <20070502100600.GZ26598@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
> Brain dump before crashing for the night:
>
> The patch refuses to clobber already-present pagetable entries of
> whatever origin. There are pagetables prior to this setup covering the
> address range just above PAGE_OFFSET. If this theory is correct, you
> should only be able to go a few MB above PAGE_OFFSET before encountering
> unreadable kernel memory. IIRC those pagetables are a statically
> allocated array in assembly; altering that array to set supervisor bits
> may resolve it, though it may also be freed as initmem.
>   

I think this should be fixed now.  Eric made all those writes
unconditional (to fix a problem with PSE superpages not being created). 
The patch is in Andi's queue.

    J
