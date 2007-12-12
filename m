Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbXLLU2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbXLLU2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXLLU2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:28:31 -0500
Received: from spirit.analogic.com ([204.178.40.4]:2122 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbXLLU2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:28:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 12 Dec 2007 20:18:31.0076 (UTC) FILETIME=[29CC9E40:01C83CFC]
Content-class: urn:content-classes:message
Subject: Re: [RESULTS] Port 0x80 I/O speed
Date: Wed, 12 Dec 2007 15:18:30 -0500
Message-ID: <Pine.LNX.4.61.0712121459570.6100@chaos.analogic.com>
in-reply-to: <47603327.6070307@keyaccess.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RESULTS] Port 0x80 I/O speed
thread-index: Acg8/CnWpbDCWdImRhCsdlA52jtsKQ==
References: <47603327.6070307@keyaccess.nl>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Rene Herman" <rene.herman@gmail.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Chris Holvenstot" <cholvenstot@comcast.net>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 12 Dec 2007, Rene Herman wrote:

> Hi everyone.
>
> That was a succesful request, thanks to all who responded. This message also
> just now went out with all the respondents in CC but I believe that copy
> isn't making the list, so here's one without...
>
> In total you provided 60 reports which are listed below in increasing order
> of time spent for an outb to port 0x0. Let's face it, these things are
> competitions, and Chris has won!
>
> Time varies between 0.54 microseconds and 2.50 microseconds, with most
> around 1.3/1.4 microseconds. Numbers 58, 59 and 60 (the ones at > 2 us) I
> dont completely trust since similar machines are among the fastest as well.
>
> Note also that ISA isn't applicable to those 3...
>
> Most machines need no delays anywhere, and those that do would probably be
> served with a udelay(1) as well but I believe this sampling is showing that
> a udelay(2) would be the conservative choice.
>
> Thanks again to all those that responded. There's probably a few cut & paste
> and/or math errors in the below. The jury can not be held accountable for
> any missed prestige!
>
> Congrats to Chris... ;-)
>
> Cheers,
>   Rene

But there are some things that get set up long before
udelay() is calibrated! The interrupt controllers,
the timer, etc. You can't just substitute or you
will end up with machines that won't boot!

grep /usr/src/linux-`uname -r`/arch/i386/kernel/*.c
for lots of outb_p()'s!

That's why the manufacturing port, 0x80, really
needs to be used for I/O timing! If it kills that
one machine, then that one machine is broken and
needs to be fixed. It's probably an undetected
error in a FPGA that once reported will get fixed.

In fact, it might just be one motherboard and
if that motherboard was replaced, the problem
goes away. We have been there before. We can't
"fix" stuff that's not broken without running
the risk of breaking a lot more stuff.

[Snipped...]


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
