Return-Path: <linux-kernel-owner+w=401wt.eu-S1031380AbXEDQoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031380AbXEDQoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031383AbXEDQoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:44:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031381AbXEDQoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:44:32 -0400
Message-ID: <463B62B3.1030408@zytor.com>
Date: Fri, 04 May 2007 09:43:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>	<1178283724.23670.70.camel@localhost.localdomain>	<1178284052.23670.75.camel@localhost.localdomain> <m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org> <463B551E.8030701@zytor.com> <463B5B90.20308@goop.org>
In-Reply-To: <463B5B90.20308@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> In 32-bit mode?  Surely you're joking, Mr. Feynman!
>>   
> 
> Right, yes.
> 
>> What's worse, reloading segments here might be highly unsafe, if the
>> memory previously occupied by the GDT has been overwritten.  Keep in
>> mind the GDT is touched on a segment *load*, not on a segment *access*;
>> in areas such as booting that can be a huge difference.
>>   
> 
> Yep, suits me.  I'm happy for the code to assume that at least %cs and
> %ds are sane; I guess %ss too.  We could copy %ds into %[efg]s if we
> want to be sure (since I could imagine a bootloader leaving them in a
> less defined state).

No, we shouldn't.  %es should be assumed set up (this is 32-bit code,
after all!), and %fs and %gs should not be used.

> But if the gdt could be missing altogether, then, yes, we should not
> touch them at all.

Exactly.  Not relying on a set-up GDT is the safest option, IMNSHO.

	-hpa
