Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYDFRaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYDFRaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 13:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYDFRaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 13:30:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbYDFRaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 13:30:04 -0400
Message-ID: <47F90788.90304@zytor.com>
Date: Sun, 06 Apr 2008 10:25:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>	 <86802c440804060003q43f14122vd527514daf77cb89@mail.gmail.com>	 <47F8FC9C.9090603@zytor.com> <86802c440804061019t1cc0e66ejee69b5d90f052b0d@mail.gmail.com>
In-Reply-To: <86802c440804061019t1cc0e66ejee69b5d90f052b0d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Sun, Apr 6, 2008 at 9:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>
>>> so will cost every bzImage extra memory copy? that could be 18M or
>>> even more big.
>>>
>>  I wouldn't worry about that.  You will typically have several copies of the
>> images during the execution of the boot loader.
> 
> i put all drivers needed in kernel.
> 1. bootloader copy bzImage (6M) to memory
> 2. arch/x86/boot/compressed/head_32.S, will copy bzImage to end of
> buffer to do uncompress on possiton.
> 3. parse_elf will copy the vmlinux (the uncompressed, that is some big, 18M)
> 
> I suggest that could have special elf header, and will only have one
> PT_LOAD, and avoid the copy, and just offset start address of
> uncompressed kernel for jump later.

Once again, I think you will have a hard time measuring the time difference.

The start address of the uncompressed kernel is defined at compile time. 
  Typically it is set based on alignment constraints in the hardware; 
for x86-32 is is normally 1 MB but for reasonably large hardware 16 MB 
is better (in fact, I have proposed making 16 MB the default.)  Recovery 
kernels are frequently compiled with completely different addresses.

With your proposal, this would no longer be possible to be a 
configurable option, which would be a major loss -- a major loss of 
functionality for a small fraction of time at bootup time (which is 
almost certainly dwarfed by all the other copying and initialization 
that happens at boot time.)

	-hpa
