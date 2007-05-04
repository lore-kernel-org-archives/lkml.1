Return-Path: <linux-kernel-owner+w=401wt.eu-S1161473AbXEDSZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161473AbXEDSZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161474AbXEDSZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:25:47 -0400
Received: from gw.goop.org ([64.81.55.164]:56247 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161473AbXEDSZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:25:46 -0400
Message-ID: <463B7AAC.90701@goop.org>
Date: Fri, 04 May 2007 11:25:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>	<1178283724.23670.70.camel@localhost.localdomain>	<1178284052.23670.75.camel@localhost.localdomain>	<m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org>	<m1r6pwr0yy.fsf@ebiederm.dsl.xmission.com> <463B6C8A.9080206@goop.org> <m11whwqymy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m11whwqymy.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>> load the segments as well.
>>>
>>> Gujin looks like it loads just %es and %ds.
>>>   
>>>       
>> We should be able to make do with that until we've got our own gdt.
>>     
>
> Right after the segments loads we have:
> 	leal 0x40(%esi), %esp
> 	call 1f
> 1:	popl %ebp
> 	subl $1b, %ebp
>
> That uses %ss and %ds.  Can we use a segment override on a call
> instruction?
>   

I overlooked Gujin missing %ss.  That's harsh.  Easy for them to fix,
presumably.

> Yes.  Exactly like we do for real mode code, and with exactly the same
> values.  Just in a little different format.

Well, fits in well with Xen's requirements, since it wants ELF notes
there for exactly the same reason.

    J
