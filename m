Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZHBREY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZHBREY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZHBREX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:04:23 -0400
Received: from mail-px0-f201.google.com ([209.85.216.201]:48897 "EHLO
	mail-px0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZHBREW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WtP5ZzJPYreyV6Et+eZ1g128QZAxz1SQwyMHBRTWHmCcW9vaveD+NiGhZ4PR4dlB8s
         FB4BErhOBDfghL/WvE/5y7fX5WlmJSjJaeT4SDVM/mIFaY1lpdbRa4Z8di1NYdh3nmXY
         3F1AknZui1F5yi5M+qySAjQbVYX652ZimB2Lg=
MIME-Version: 1.0
In-Reply-To: <20090802115826.0174f292@lxorguk.ukuu.org.uk>
References: <h51hro$p6j$1@ger.gmane.org> <4A748A48.8020702@gmail.com>
	 <cdb43e8a0908011544o69c2203dv39ce5a04840e0869@mail.gmail.com>
	 <20090802115826.0174f292@lxorguk.ukuu.org.uk>
Date: Sun, 2 Aug 2009 11:04:23 -0600
Message-ID: <51f3faa70908021004q8ed8a92q6d67857d4731d45c@mail.gmail.com>
Subject: Re: Extremely slow IO with a PCMCIA CompactFlash adapter
From: Robert Hancock <hancockrwd@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jack Byer <ojbyer@usa.net>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 4:58 AM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
>> irq 3: nobody cared (try booting with the "irqpoll" option)
>> Pid: 23488, comm: modprobe Not tainted 2.6.31-rc4 #2
>> Call Trace:
>
> Something is misrouting interrupts on your machine. COuld be an ACPI bug,
> could be wrong tables in the BIOS etc.
>
>> Now I rebooted with irqpoll and everything looks good in dmesg:
>
> It will recover from the problem sort of
>
>> Now my transfer rate has increased to 20 kilobyte / second read, about
>> 4 times faster than before but still pretty slow.
>
> You should see nearer 200K/sec (PIO 0) but if the device IRQ is being
> lost due to misrouting then the device is being polled off the timer tick
> and that will drastically reduce performance.
>
> So its a firmware/acpi/irq sort of problem not an IDE one. Try running
> with acpi=off and without irqpoll just as a test.

I'm kind of doubtful it's a misrouting, the driver thinks it should be
on IRQ3 and we end up getting spurious interrupts on IRQ3, so I'm
guessing that somehow that card is producing excess interrupts that
we're not expecting, or something?
