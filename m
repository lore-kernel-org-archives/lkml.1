Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYFJTJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYFJTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYFJTJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:09:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:7464 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYFJTJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Oz6/il0saBMOeDootTCaX0RK4Am3JP2sLtXeYHJYPYn/GMFS66NY/f61HtVqQCbxgc
         AJnqx1KIeRTOKLFWeNQho3Zicqe9TUF5F4JSABVUNcsMr49j3S5DyRfnqurOXqwelwrr
         g7nNv5yRjWg/eG2zZb9RpSxZAxLJ8BBWzhhxI=
Message-ID: <86802c440806101209q301bcef0ia859db7e587bd42e@mail.gmail.com>
Date: Tue, 10 Jun 2008 12:09:20 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
In-Reply-To: <Pine.LNX.4.55.0806101418510.1702@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
	 <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>
	 <484D8813.4040807@redhat.com>
	 <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>
	 <86802c440806091353m240ab7adocbaf5dacd15504f7@mail.gmail.com>
	 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl>
	 <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl>
	 <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com>
	 <484E7B03.8000604@redhat.com>
	 <Pine.LNX.4.55.0806101418510.1702@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 6:30 AM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Tue, 10 Jun 2008, Glauber Costa wrote:
>
>> >>  Then again -- what if X86_LOCAL_APIC is set, but X86_IO_APIC is not?
>> >
>> > config X86_LOCAL_APIC
>> >         def_bool y
>> >         depends on X86_64 || (X86_32 && (X86_UP_APIC || ((X86_VISWS ||
>> > SMP) && !X86_VOYAGER) || X86_GENERICARCH))
>> >
>> > config X86_IO_APIC
>> >         def_bool y
>> >         depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP &&
>> > !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH))
>> >
>> > for 64bit, those are all set.
>> >
>> > for 32bit, may need to null stub if X86_IO_APIC is not set
>> >
>> > YH
>> Fair Enough.
>
>  That does not answer the question what to do with a 32-bit kernel run on
> a system that requires the fixup in the 64-bit mode.  Papering over such
> firmware bugs in the kernel encourages hardware vendors to maintain the
> breakage.

kernel should not assume io apic register is set right by firmware.
and kernel actually doesn't trust them, and clear the io apic registers.
that patch just move that early before enable error vector.

YH
