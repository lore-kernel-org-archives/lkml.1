Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbXJYL7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbXJYL7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbXJYL7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:59:36 -0400
Received: from spirit.analogic.com ([204.178.40.4]:4723 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbXJYL7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:59:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 25 Oct 2007 11:58:57.0431 (UTC) FILETIME=[6C495A70:01C816FE]
Content-class: urn:content-classes:message
Subject: Re: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 07:58:56 -0400
Message-ID: <Pine.LNX.4.61.0710250753350.22665@chaos.analogic.com>
In-reply-to: <200710250915.50675.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Is gcc thread-unsafe?
Thread-Index: AcgW/mxSk2o/pR91TBam4cWt9VUhYw==
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710250915.50675.ak@suse.de>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Andi Kleen" <ak@suse.de>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Oct 2007, Andi Kleen wrote:

> On Thursday 25 October 2007 05:24, Nick Piggin wrote:
>
>> Basically, what the gcc developers are saying is that gcc is
>> free to load and store to any memory location, so long as it
>> behaves as if the instructions were executed in sequence.
>
> This case is clearly a bug, a very likely code pessimization.
> I guess it wasn't intentional, just an optimization that is useful
> for local register values doing too much.


I don't think it is a BUG, but one should certainly be able
to turn it off. Gcc is correct in that the 'C' language allows
a lot of implimentation details that are not covered by the
language. In other words, 'C' is not assembly-language.


>
>> I guess that dynamically allocated memory and computed pointers
>> are more difficult for gcc to do anything unsafe with, because
>> it is harder to tell if a given function has deallocated the
>> memory.
>
> Often accesses happen without function calls inbetween.
> Also I think newer gcc (not 3.x) can determine if a pointer
> "escapes" or not so that might not protect against it.
>
>> Any thoughts?
>
> We don't have much choice: If such a case is found it has to be marked
> volatile or that particular compiler version be unsupported.
>
> It might be useful to come up with some kind of assembler pattern
> matcher to check if any such code is generated for the kernel
> and try it with different compiler versions.
>
> -Andi

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
