Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXKEWAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXKEWAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbXKEWAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:00:03 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38754 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXKEWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:00:00 -0500
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
	<m1ir4g9yy7.fsf@ebiederm.dsl.xmission.com>
	<472F8B1B.2070402@zytor.com>
Date: Mon, 05 Nov 2007 14:58:58 -0700
In-Reply-To: <472F8B1B.2070402@zytor.com> (H. Peter Anvin's message of "Mon,
	05 Nov 2007 13:28:59 -0800")
Message-ID: <m1abps9wwt.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>
>> I'm just saying be liberal in what you accept and conservative in what
>> you send.
>>
>
> Absolutely.
>
>> Making the entire process well defined is useful so things don't break
>> unnecessarily, and the maintainers of the pieces of software that use
>> the interface know what they can reliably get away with and what is
>> just luck.
>>
>> Currently using the 32-bit entry point reliably requires:
>> %cs to be set.
>> %esi to be set.
>> %ebx be set to 0.
>> %gdt to be set and have:
>>   0x10 a 32bit 4G code segment with base of 0
>>   0x18 a 32bit 4G data segment with base of 0
>>
>
> Actually, I suspect the currently code will handle %ebx with any value, but some
> older kernels might not handle that correctly.

Correct.  So a bootloader must set %ebx to zero to handle those older kernels.
Since it has always been this way we can count on it.

>> With the latest generation of the boot protocol if KEEP_SEGMENTS
>> is set then it is only required that the data segments %ds, %es, %fs,
>> %gs and %ss be initialized to a valid value.
>>
>> I have no problem with code providing more then what is required
>> above, and in fact I think it is likely a good thing.
>>
>> For future expansion of the protocol things will go easiest if
>> we don't add additional requirements to the list above, as that
>> is all that I think all current boot loaders provide.
>
> Specifying now that unused GPRs should be zeroed will allow for changes if and
> when we need it.  It's an easy requirement to fulfill, so boot loader authors
> can put it through the pipe now.  Then, if we find ourselves in a corner in the
> future, we have a possible out.

Sure it is reasonable to ask for.  The bootloader pipe is awfully long though.
But putting it in at the time we clean up the rules for the 32bit entry point
is the best chance we are going to get to be able to change things.

Eric

