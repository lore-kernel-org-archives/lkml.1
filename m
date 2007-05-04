Return-Path: <linux-kernel-owner+w=401wt.eu-S1161228AbXEDRZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161228AbXEDRZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161303AbXEDRZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:25:32 -0400
Received: from gw.goop.org ([64.81.55.164]:57214 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161228AbXEDRZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:25:31 -0400
Message-ID: <463B6C8A.9080206@goop.org>
Date: Fri, 04 May 2007 10:25:30 -0700
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
References: <1178283582.23670.67.camel@localhost.localdomain>	<1178283724.23670.70.camel@localhost.localdomain>	<1178284052.23670.75.camel@localhost.localdomain>	<m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org> <m1r6pwr0yy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6pwr0yy.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Hmm. If we made that:
> 	mov	%cs, %eax
> 	add	$0x10, %eax
> 	mov	%eax, %ds
>
> That is likely even backwards compatible.  If you don't mind having a fixed
> offset between the code and the data segments.  As I recall code and data
> are not interchangeable.
>   

Yes, that's just bogus thinko on my part.

> I'm trying to remember the reason for the reloads.
>
> As I recall loadlin intercepts code32_start from head.S and so it
> can do things just after we have switched to protected mode.  Because
> historically we didn't load the segments before this jump loadlin had
> to do it.  The code of loadlin appears to reload all of the segments
> just like head.S does and then not touch them.
>
> My two bootloaders that enter the kernel at the 32bit entry point already
> load the segments as well.
>
> Gujin looks like it loads just %es and %ds.
>   

We should be able to make do with that until we've got our own gdt.

> It is hard to tell with elilo what it sets up, it preserves the
> descriptors from EFI, but sets up a linux boot protocol gdt.
>   

? But the cached descriptors are still the EFI ones?

> Since setup.S finally does the right thing in loading segment
> registers.  It looks to me like we need to sit down and document
> the 32bit kernel interface, as it is today, and then extend
> things to just replicate %ds into the other segments, and kill
> any lss instructions.
>   

Yes.

> At the same time we are doing this it would be good to drop our
> boot protocol version into an ELF note so people booting vmlinux
> can discover when we have relaxed various restrictions and which
> fields in the real mode data we support.
>   

Do you mean the have the kernel expose its max supported version for
bootloaders to inspect?

    J
