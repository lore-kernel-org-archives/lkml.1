Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbXKEV3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbXKEV3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXKEV3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:29:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXKEV33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:29:29 -0500
Message-ID: <472F8B1B.2070402@zytor.com>
Date: Mon, 05 Nov 2007 13:28:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>	<472F5941.2060507@zytor.com>	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>	<472F61C8.4040300@zytor.com>	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org>	<m1pryoa1f6.fsf@ebiederm.dsl.xmission.com>	<472F7D8D.8050505@zytor.com> <m1ir4g9yy7.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ir4g9yy7.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I'm just saying be liberal in what you accept and conservative in what
> you send.
> 

Absolutely.

> Making the entire process well defined is useful so things don't break
> unnecessarily, and the maintainers of the pieces of software that use
> the interface know what they can reliably get away with and what is
> just luck.
> 
> Currently using the 32-bit entry point reliably requires:
> %cs to be set.
> %esi to be set.
> %ebx be set to 0.
> %gdt to be set and have:
>   0x10 a 32bit 4G code segment with base of 0
>   0x18 a 32bit 4G data segment with base of 0
> 

Actually, I suspect the currently code will handle %ebx with any value, 
but some older kernels might not handle that correctly.

> With the latest generation of the boot protocol if KEEP_SEGMENTS
> is set then it is only required that the data segments %ds, %es, %fs,
> %gs and %ss be initialized to a valid value.
> 
> I have no problem with code providing more then what is required
> above, and in fact I think it is likely a good thing.
> 
> For future expansion of the protocol things will go easiest if
> we don't add additional requirements to the list above, as that
> is all that I think all current boot loaders provide.

Specifying now that unused GPRs should be zeroed will allow for changes 
if and when we need it.  It's an easy requirement to fulfill, so boot 
loader authors can put it through the pipe now.  Then, if we find 
ourselves in a corner in the future, we have a possible out.

> Anyway this is getting off topic.  So far the changes to pmjump.S
> look to be going well.

Thanks.  I just pushed two more patches to the git tree; one to do the 
paranoia thing, and one to initialize LDTR and TR; the latter is for the 
benefit of Intel VT and is not required for correctness, but it should 
be able to speed up booting slightly on VT-based hardware.

See:

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-x86setup.git;a=log;h=for-linus

	-hpa
