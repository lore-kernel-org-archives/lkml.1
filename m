Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXBVRX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXBVRX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXBVRX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:23:58 -0500
Received: from lmv.inov.pt ([146.193.64.2]:42799 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXBVRX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:23:57 -0500
Message-ID: <20070222172103.lspdvgh80sg804k0@webmail.inov.pt>
Date: Thu, 22 Feb 2007 17:21:03 +0000
From: jose.goncalves@inov.pt
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
References: <20070219143520.GB27370@flint.arm.linux.org.uk>
	<20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk>
	<45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk>
	<45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk>
	<45DC537B.6020108@inov.pt> <20070221230503.GA28156@flint.arm.linux.org.uk>
	<45DDB096.2020807@inov.pt> <20070222170354.GB633@flint.arm.linux.org.uk>
In-Reply-To: <20070222170354.GB633@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.0.4)
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Russell King <rmk+lkml@arm.linux.org.uk>:

> On Thu, Feb 22, 2007 at 03:02:46PM +0000, Jose Goncalves wrote:
>> It could be a silly question (tamper with me as I'm not familiar with
>> such low level programming), but couldn't it be possible for a interrupt
>> to hit in the middle of the serial_in() calls and mess with %ebx?
>
> I'm no expert on x86, but if an interrupt was messing with %ebx, you'd
> have random crashes verywhere - userspace, kernel space in unpredicatable
> ways.
>
>> What I find real hard to understand is why a hardware fault happens
>> always in the same software instruction! I would expect a hardware fault
>> to hit randomly...
>
> Well, compared with your previous report, your latest report is different.
> Your first report had  both EIP and %ebx being zero (because they got
> corrupted when returning from serial_in).  This time only %ebx was
> corrupted.
>
> Consequently, this time we oopsed in the subsequent serial_in() rather
> than trying to return to serial8250_startup() as last time.

But there was also another difference. I CONFIGed the kernel to produce 
more debug info. This should influence the Oops report...

>
>> I left my application running this night, with a 2.6.16.41 kernel
>> unpatched  on the serial driver (my last Oops report was with Frederik
>> patch to remove the insertion made in 2.6.12) and it crashed again on
>> exactly the same point!
>
>> From that I take it that you removed the test in serial8250_startup which
> sets UART_BUG_TXEN, and the problem persisted.  That tends to suggest
> that it's not the culpret.

 From that I mean that with or without this code - 
http://lkml.org/lkml/2007/2/19/124 - the problem persisted. The 
difference is that, without it, the crashes happens more sparsly.

José Gonçalves


