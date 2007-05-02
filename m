Return-Path: <linux-kernel-owner+w=401wt.eu-S1766974AbXEBRxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766974AbXEBRxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766976AbXEBRxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:53:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59459 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766974AbXEBRxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:53:22 -0400
Date: Wed, 2 May 2007 10:52:20 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bill Irwin <bill.irwin@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, wli@holomorphy.com
Subject: Re: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
Message-ID: <20070502175220.GB26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
	Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
	Ingo Molnar <mingo@elte.hu>
References: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com> <20070502005140.b94500ff.akpm@linux-foundation.org> <20070502084617.GY26598@holomorphy.com> <20070502100600.GZ26598@holomorphy.com> <4638BC3E.9080708@goop.org> <20070502163244.GA26598@holomorphy.com> <m1k5vrw3h0.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k5vrw3h0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 09:28:46AM -0700, Jeremy Fitzhardinge wrote:
>>> I think this should be fixed now.  Eric made all those writes
>>> unconditional (to fix a problem with PSE superpages not being created). 
>>> The patch is in Andi's queue.

Bill Irwin <bill.irwin@oracle.com> writes:
>> It needs verification with the testcase from this thread.

On Wed, May 02, 2007 at 11:16:27AM -0600, Eric W. Biederman wrote:
> Sounds reasonable.
> However there is no reason to suspect it won't fix this case because
> unconditional writes are what we have always done, and we have always
> kept swapper_pg_dir from early boot as well.
> In essence my patch I sent out to Andi was a partial revert.

It would not be so far out to be aware of what pagetable entries were
carried over from the initial swapper_pg_dir and explicitly clobber
them (for instance, modifying their protection bits while otherwise
retaining them).


On Wed, May 02, 2007 at 11:16:27AM -0600, Eric W. Biederman wrote:
> It isn't slated to go in until nextround but I also rewrote the early
> page table setup in C.  Allowing set_fixmap to work in the early
> kernel, and fix problems of not having enough memory mapped to build
> the identity mappings, because we are then updating the page table
> we have also in the PAE case.

I'm not sure when we run into those problems, though I understand what
they are. I suppose it would be good to resolve them.


-- wli
