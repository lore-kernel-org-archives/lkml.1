Return-Path: <linux-kernel-owner+w=401wt.eu-S1946446AbXBINQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946446AbXBINQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946447AbXBINQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:16:11 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:4207 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946446AbXBINQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:16:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
X-OriginalArrivalTime: 09 Feb 2007 13:16:07.0806 (UTC) FILETIME=[75A101E0:01C74C4C]
Content-class: urn:content-classes:message
Subject: Re: somebody dropped a (warning) bomb
Date: Fri, 9 Feb 2007 08:16:06 -0500
Message-ID: <Pine.LNX.4.61.0702090755530.7642@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0702091330380.31955@yvahk01.tjqt.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: somebody dropped a (warning) bomb
Thread-Index: AcdMTHWqr0C7wpeJRKuqnuna+2iB5A==
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702091330380.31955@yvahk01.tjqt.qr>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Rientjes" <rientjes@google.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 9 Feb 2007, Jan Engelhardt wrote:

>
> On Feb 8 2007 16:42, Linus Torvalds wrote:
>>
>> Most C types don't, and some you can't even tell (do pointers generate
>> "signed" or "unsigned" comparisons?
>
> I'd say "neither", because both
>
>    signed void *ptr; and
>    unsigned void *xyz;
>
> are impossible (and dull at that). That's why you explicitly will
> have to cast one operand in a comparison to make it evident
> what sort of comparison is intended, i.e.
>
>    if((unsigned long)ptr < PAGE_OFFSET)
>
> Further, giving again answer to the question whether they generate signed or
> unsigned comparisons: Have you ever seen a computer which addresses memory with
> negative numbers? Since the answer is most likely no, signed comparisons would

Yes, most all do. Indexed memory operands are signed displacements. See
page 2-16, Intel486 Microprocessor Programmer's Reference Manual. This
gets hidden by higher-level languages such as 'C'. It is also non-obvious
when using the AT&T (GNU) assembly language. However, the Intel documentation
shows it clearly:
 			MOV	AL,  [EBX+0xFFFFFFFF]	; -1

...will put the byte existing at the location just BEFORE the offset in
EBX, into register AL, while:

 			MOV	AL,  [EBX+0x00000001]  ; +1

...will put the byte existing at the location just AFTER the offset in
EBX, into register AL.

Also, the documentation specifically states that sign extension is
provided for all effective address calculations.

> not make sense for me.
>
>> I'll argue that a compiler that
>> generates signed comparisons for them is broken, but it tends to be
>> something you can only see with a standards- conforming proghram if you
>> can allocate memory across the sign boundary, which may or may not be
>> true..)
>
> Jan
> -- 
> ft: http://freshmeat.net/p/chaostables/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.61 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
