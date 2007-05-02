Return-Path: <linux-kernel-owner+w=401wt.eu-S2993460AbXEBQeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993460AbXEBQeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993468AbXEBQeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:34:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:60023 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993460AbXEBQeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:34:15 -0400
Date: Wed, 2 May 2007 09:32:44 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Bill Irwin <bill.irwin@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, wli@holomorphy.com
Subject: Re: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
Message-ID: <20070502163244.GA26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
	Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
	Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com> <20070502005140.b94500ff.akpm@linux-foundation.org> <20070502084617.GY26598@holomorphy.com> <20070502100600.GZ26598@holomorphy.com> <4638BC3E.9080708@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4638BC3E.9080708@goop.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
>> Brain dump before crashing for the night:
>> The patch refuses to clobber already-present pagetable entries of
>> whatever origin. There are pagetables prior to this setup covering the
>> address range just above PAGE_OFFSET. If this theory is correct, you
>> should only be able to go a few MB above PAGE_OFFSET before encountering
>> unreadable kernel memory. IIRC those pagetables are a statically
>> allocated array in assembly; altering that array to set supervisor bits
>> may resolve it, though it may also be freed as initmem.

On Wed, May 02, 2007 at 09:28:46AM -0700, Jeremy Fitzhardinge wrote:
> I think this should be fixed now.  Eric made all those writes
> unconditional (to fix a problem with PSE superpages not being created). 
> The patch is in Andi's queue.

It needs verification with the testcase from this thread.


-- wli
