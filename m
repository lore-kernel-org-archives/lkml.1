Return-Path: <linux-kernel-owner+w=401wt.eu-S1161485AbXDWS5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161485AbXDWS5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161488AbXDWS5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:57:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54140 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161485AbXDWS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:57:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
References: <20070414204154.871250608@goop.org>
	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>
	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>
	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>
	<m1d51vxxm4.fsf@ebiederm.dsl.xmission.com> <462CE027.4030302@goop.org>
	<462CE1E0.9060007@zytor.com>
	<m1zm4zvwfr.fsf@ebiederm.dsl.xmission.com>
	<462CF5B8.4070708@xensource.com>
Date: Mon, 23 Apr 2007 12:54:47 -0600
In-Reply-To: <462CF5B8.4070708@xensource.com> (Jeremy Fitzhardinge's message
	of "Mon, 23 Apr 2007 11:06:48 -0700")
Message-ID: <m1y7kivs3s.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@xensource.com> writes:

> Eric W. Biederman wrote:
>> Consider a memory hole of size 8M immediately after our bootmem bitmap.
>> head.S which knows nothing of holes will map the pages of the hole
>> into the initial page tables assuming that is where the page tables
>> will live.
>>   
>
> Sure, but considering we're only talking about mapping an additional *2*
> pages, the chances are that it will affect a kernel as much as the early
> head.S mapping.  It's well within the variability of fairly similar
> kernel configs.

If (cpu_has_pse) it may only be an additional two pages.
INIT_MAP_BEYOND is currently mapping a lot more then that.

>> As for how to fix this, we need to call boot_ioremap or better
>> bt_ioremap on the address returned from alloc_bootmem_pages_low to
>> force the allocated page into the page table.  After we have setup
>> the page table page we can call unmap the page to free up the scarce
>> early mapping resource.
>>   
>
> Would that be necessary?  Is there any need to remap it?  Couldn't you
> just do the straightforward phys->virt mapping and use the page where it
> lies?

Catch-22.  If the page is not mapped yet you can't use it where it lies.

Eric
