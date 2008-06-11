Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYFKCcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYFKCcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 22:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYFKCcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 22:32:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:40715 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYFKCcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 22:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oajo6OT/Q6UUajY/hr8Jy5FI8nIM0G9FKBY1mTr/ksuqn+m14/qXvhhuCqil97T+zW
         SDmuDMwnWxY/h5v7BiedVUmVhOf5UfiZCf3/Q8SAQ8KpowQfr4b+wLSJb//243r4RGrw
         AnZkwSec9/uSwVn+bWM1ac1jDzOSxdpRdi2ZE=
Message-ID: <86802c440806101932s1bde646at322df320d02bfdb@mail.gmail.com>
Date: Tue, 10 Jun 2008 19:32:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
In-Reply-To: <Pine.LNX.4.55.0806110122580.1702@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
	 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl>
	 <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl>
	 <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com>
	 <484E7B03.8000604@redhat.com>
	 <Pine.LNX.4.55.0806101418510.1702@cliff.in.clinika.pl>
	 <86802c440806101209q301bcef0ia859db7e587bd42e@mail.gmail.com>
	 <Pine.LNX.4.55.0806102025460.1702@cliff.in.clinika.pl>
	 <86802c440806101249i3650aa59u1090110a803c3384@mail.gmail.com>
	 <Pine.LNX.4.55.0806110122580.1702@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 5:29 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Tue, 10 Jun 2008, Yinghai Lu wrote:
>
>> ExtINT is routed to ioapic pin0. but the dst is set to 0.
>> and the systems has multi sockets with quadcore cpu, so the apic id of boot cpu
>> is set to 4 instead of 0
>
>  Thanks for the info.  Let me understand the situation better: local APIC
> IDs are preassigned by the firmware based on their "socket address" and
> the socket where the lowest numbered quad would be is empty.
> Nevertheless the firmware sets the destination ID of the ExtINTA interrupt
> in the I/O APIC to 0 rather than the ID of the bootstrap CPU.  Is that
> correct?

Yes

after I asked bios engineer to change the dest apic id to 4, the error is gone.

before clear_IO_APIC()
number of MP IRQ sources: 15.
number of IO-APIC #0 registers: 24.
number of IO-APIC #1 registers: 7.
number of IO-APIC #2 registers: 7.
number of IO-APIC #3 registers: 24.
testing the IO APIC.......................

IO APIC #0......
.... register #00: 00000000
.......    : physical APIC id: 00
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 004 0    0    0   0   0    0    7    00
 01 000 1    0    0   0   0    0    0    00
 02 000 1    0    0   0   0    0    0    00
 03 000 1    0    0   0   0    0    0    00
 04 000 1    0    0   0   0    0    0    00
 05 000 1    0    0   0   0    0    0    00
 06 000 1    0    0   0   0    0    0    00
 07 000 1    0    0   0   0    0    0    00
 08 000 1    0    0   0   0    0    0    00
 09 000 1    0    0   0   0    0    0    00
 0a 000 1    0    0   0   0    0    0    00
 0b 000 1    0    0   0   0    0    0    00
 0c 000 1    0    0   0   0    0    0    00
 0d 000 1    0    0   0   0    0    0    00
 0e 000 1    0    0   0   0    0    0    00
 0f 000 1    0    0   0   0    0    0    00
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00


>
>  But it would mean the Virtual Wire interrupt delivery would not work, or
> is the I/O APIC setup redundant and the local APIC of the bootstrap CPU is
> set up for ExtINTA delivery as well?

it doesn't need to virtual wire for timer (ExtInt), timer is hpet and
routed to ioapic pin2.

Just know at first BIOS engineer refused to change that to 4, because
other os is not happy.

YH
