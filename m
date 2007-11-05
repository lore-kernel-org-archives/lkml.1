Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbXKEVQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbXKEVQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXKEVPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:15:55 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33780 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXKEVPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:15:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>
	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>
	<472F5941.2060507@zytor.com>
	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>
	<472F61C8.4040300@zytor.com>
	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org>
	<m1pryoa1f6.fsf@ebiederm.dsl.xmission.com>
	<472F7D8D.8050505@zytor.com>
Date: Mon, 05 Nov 2007 14:14:56 -0700
In-Reply-To: <472F7D8D.8050505@zytor.com> (H. Peter Anvin's message of "Mon,
	05 Nov 2007 12:31:09 -0800")
Message-ID: <m1ir4g9yy7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>>
>>>> However, that being said, doing so is trivial, and it might help some
>>>> debugging hack; anything that makes debugging easier is a Good Thing[TM].
>>> Yeah. Even if it was just re-using the boot-time stack area temporarily, just
>>> to give code the choice to use a common set of instructions.
>>
>> If I had to do it from scratch today I would make the 32-bit entry
>> point require a stack, segments and use C calling conventions to pass
>> struct boot_params *.
>>
>> Besides %esi I'm not really fond of requiring anything in the 32bit
>> entrypoint.  At the same time I totally agree that it is always nice
>> to provide way more then you need.
>>
>
> Nailing down the interface as hard as possible is a good idea, to avoid tying
> your hands for the future.
>
> 	-hpa


I'm just saying be liberal in what you accept and conservative in what
you send.

Making the entire process well defined is useful so things don't break
unnecessarily, and the maintainers of the pieces of software that use
the interface know what they can reliably get away with and what is
just luck.

Currently using the 32-bit entry point reliably requires:
%cs to be set.
%esi to be set.
%ebx be set to 0.
%gdt to be set and have:
  0x10 a 32bit 4G code segment with base of 0
  0x18 a 32bit 4G data segment with base of 0

With the latest generation of the boot protocol if KEEP_SEGMENTS
is set then it is only required that the data segments %ds, %es, %fs,
%gs and %ss be initialized to a valid value.

I have no problem with code providing more then what is required
above, and in fact I think it is likely a good thing.

For future expansion of the protocol things will go easiest if
we don't add additional requirements to the list above, as that
is all that I think all current boot loaders provide.

Anyway this is getting off topic.  So far the changes to pmjump.S
look to be going well.

Eric
