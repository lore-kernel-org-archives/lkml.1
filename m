Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXEDPLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXEDPLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbXEDPLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:11:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58707 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbXEDPLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:11:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type" boot header field
References: <1178283582.23670.67.camel@localhost.localdomain>
	<m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>
	<1178288329.23670.86.camel@localhost.localdomain>
Date: Fri, 04 May 2007 09:10:15 -0600
In-Reply-To: <1178288329.23670.86.camel@localhost.localdomain> (Rusty
	Russell's message of "Sat, 05 May 2007 00:18:49 +1000")
Message-ID: <m1ejlwsjzc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Fri, 2007-05-04 at 08:01 -0600, Eric W. Biederman wrote:
>> We should place that initial branch right after startup_32,
>> we don't need the startup_paravirt at all now.
>> 
>> ENTRY(startup_32)
>> #ifdef CONFIG_LGUEST_GUEST
>>         cmpl	$1, 0x23c(%esi)
>> 	je      lguest_init
>> #endif
>
> Hi Eric!
>
> 	Makes sense to me, but I wasn't sure... do we need to check for old
> bootloader versions and such?

Thinking about this a little more.  It probably makes sense to move the
test for lguest down to just before we initialize the page tables.  That
way we can share common bss clearing code and parameter parsing setup
code.

Eric

