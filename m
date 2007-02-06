Return-Path: <linux-kernel-owner+w=401wt.eu-S965450AbXBFUzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965450AbXBFUzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXBFUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:55:47 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50169 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965450AbXBFUzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:55:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: "H. Peter Anvin" <hpa@zytor.com>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Re : Re : Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <199171.13576.qm@web26913.mail.ukl.yahoo.com>
Date: Tue, 06 Feb 2007 13:55:04 -0700
In-Reply-To: <199171.13576.qm@web26913.mail.ukl.yahoo.com> (Etienne Lorrain's
	message of "Tue, 6 Feb 2007 20:30:04 +0000 (GMT)")
Message-ID: <m1ejp3ropj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:

>  I am not sure to understand: Gujin calls a function inside the ELF real
> mode program header of the Linux kernel. All the system is currently
> in real mode. There isn't any limitation in this function of the kernel to
> decide to print some message and not return at all, this function can
> selectively do so by reading which bootloader ID it is using (another
> parameter). It is not done mostly because "printf" is difficult to do
> in assembler, Gujin has no problem.

This code is currently completely Gujin specific.  If concieved as a
replacement for setup.S it has a chance of passing review.

>> Is your real mode C code section relative such that it can be loaded
>> at different addresses and still work?
>
>   The code is relative - but not the data (first 4 Kbytes at %ds:0 and stack
>  available) - but the whole lot at any segment boundary, i.e. every 16 bytes.
>  Else Gujin would not work under DOS.

Ok.  Similar restrictions to the current real mode code.

>> The program header is for executable loaders the section header is for
>> linkers and the section header is optional in PT_LOAD and PT_DYN
>> executables.  Use of the section header by a loader is a bug.
>
>   Unless if there is a problem, Gujin uses only the program header;
>  it has a look in the section header just in case - that can be removed
>  easily. I was wondering about a relocatable image there - but I do
>  not know enough for that.

When you are relocatable no relocations are processed and all addresses in
the program header are slid by some fixed amount (preserving alignment)
after that the relocated object has to work out the relocations by itself.

>> >   Well, you can generate with the proposed patch and boot with SYSLINUX,
>> >  Grub and LILO, but trying to clean Linux real-mode code is where I begun.
>>
>> I haven't looked yet.  But I believe this is something that we can do,
>> so long as cleaning and feature enhancement are not mixed in a bad way.
>> Phrasing this another way.  What we can do with the interface is
>> determined our interface to existing bootloaders and what bootloaders
>> exist.  Basically it is the rule that we need to preserve backwards
>> compatibility and changes generally need to be evolutionary ones.
>
>   Well, if you want to preserve compatibility with other bootloaders,
>  it is probably possible to put some source around the ELF kernel file,
>  mostly taken from Gujin if you want (GPL), but I wonder why you would
>  like to be compatible with LILO.

LILO is a lot saner then Grub, and it still supports more filesystems...
Just because it memorizes it all before you shut down the system for
simplicity doesn't mean lilo is worse.

>  Modifying the linux real mode assembler, nobody could even want to.

I have several times.  It's just code.  But I do agree it will likely
be more maintainable if we can convert it to C.

On that same token I wrote a compiler in romcc in another context so I
didn't have to write so much assembly.  And for maintainability and
comprehensibility it was a big help.

Eric
