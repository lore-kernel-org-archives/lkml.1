Return-Path: <linux-kernel-owner+w=401wt.eu-S965305AbXBFS5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965305AbXBFS5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXBFS5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:57:38 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47369 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965305AbXBFS5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:57:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: "H. Peter Anvin" <hpa@zytor.com>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Re : Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <988792.74810.qm@web26913.mail.ukl.yahoo.com>
Date: Tue, 06 Feb 2007 11:57:01 -0700
In-Reply-To: <988792.74810.qm@web26913.mail.ukl.yahoo.com> (Etienne Lorrain's
	message of "Tue, 6 Feb 2007 18:39:11 +0000 (GMT)")
Message-ID: <m17iuvt8qq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:

> Eric W. Biederman wrote:
>> Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:
>> >  New features are more that this real-mode function can return an error
>> >  to the bootloader to tell something to the user, so the user can select
>> >  another kernel with the right processor, another video mode... with
>> >  clean error messages - not a crash dump because this assembly
>> >  instruction is not for that processor.
>>
>> Having an error handling compatibility that is backwards compatible sounds
>> interesting.
>
>  Well, if the function called at offset 0 in the real-mode section return
>  non zero, that is probably an error - that is Gujin interface, but do not ask
>  me to change other bootloaders to handle that.
>  This function is called with few parameters, one is a string pointer
>  if the function do not want to print the problem report itself.
>  The function is called with an offset of zero in its own intel
>  segment.

So I think there are some backwards compatibility issues with your
real mode code interface.  Setting a new flag that says to return instead
of printing an error message and halting would be one way to handle
this.

Is your real mode C code section relative such that it can be loaded
at different addresses and still work?

>> >   I am still saying that the bootloader knows the root filesystem to
>> >  be used by the kernel it loads, and that ELF is a clean format to
>> >  store different sections to be loaded into memory at predefined
>> >  addresses.
>> 
>> Yes.  Although when you think sections instead of segments I'm a little
>> worried.
>
>   Well, for my defense, if Gujin do not find the real mode code in the program
>  header it search for it in the section table, if the program header cannot be
>  modified for some reason. There may be some issues if that ELF file is
>  "stripped" but it seems to work on my side.

The program header is for executable loaders the section header is for
linkers and the section header is optional in PT_LOAD and PT_DYN
executables.  Use of the section header by a loader is a bug.

>> >  Also there isn't any more kernel size limit.
>>
>> I think as HPA points out we have gotten past that a long time
>> ago with the bzImage format.
>
>   There was still a test not that long ago (in the code I am not executing) -
> but
>  I was wrong to bring this point forward.

There have been limitations but mostly with respect to page table size
and the like but they were not limitations a bootloader had to deal with.

>> With the right delicacy, and preserving backwards compatibility
>> with existing bootloaders I think we can achieve things.
>
>   Well, you can generate with the proposed patch and boot with SYSLINUX,
>  Grub and LILO, but trying to clean Linux real-mode code is where I begun.

I haven't looked yet.  But I believe this is something that we can do,
so long as cleaning and feature enhancement are not mixed in a bad way.

>> The big issue is that sometimes bootloaders are a little bit brittle.
>> Eric
>
>   I like to think mine is more stable - maybe I am a dreamer...
>   I do not compete on network booting neither.

Phrasing this another way.  What we can do with the interface is
determined our interface to existing bootloaders and what bootloaders
exist.  Basically it is the rule that we need to preserve backwards
compatibility and changes generally need to be evolutionary ones.

Eric
