Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbYETPYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbYETPYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933182AbYETPW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:22:26 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:1443 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbYETPWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:22:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 20 May 2008 15:22:20.0756 (UTC) FILETIME=[4BF4F940:01C8BA8D]
Content-class: urn:content-classes:message
Subject: Re: UML fails to locate address space
Date: Tue, 20 May 2008 11:22:08 -0400
Message-ID: <Pine.LNX.4.61.0805201117540.12360@chaos.analogic.com>
In-Reply-To: <20080520135238.GB6990@c2.user-mode-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: UML fails to locate address space
thread-index: Aci6jUwRuglfMfRYRBKya6QM4qvNjw==
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com> <20080520135238.GB6990@c2.user-mode-linux.org>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Jeff Dike" <jdike@addtoit.com>
Cc: "Tom Spink" <tspink@gmail.com>, "LKML" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1026-15922.000
X-TM-AS-Result: No--17.884400-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 May 2008, Jeff Dike wrote:

> On Tue, May 20, 2008 at 12:08:24PM +0100, Tom Spink wrote:
>> I've just recently pulled the latest GIT and compiled UML, however,
>> when I run it a message appears saying "Locating the top of the
>> address space... Address 0x0 no good?" and the program exits.
>
> Can you strace it and send me the output?
>
>> After some digging, it appears that page_ok is returning false when
>> checking 'bottom', in os_get_task_size
>> (arch/um/os-Linux/sys-i386/task_size.c:96).  After running through
>> GDB, it seems that in line 31 of that file is where the segfault
>> occurs:
>>
>> n = *address;
>>
>> i.e. when trying to read from the address space (at address zero).
>
> The segfaults are on purpose - it will trap SIGSEGV and longjmp out of
> the handler and mark the affected address as not-usable.
>
>    	       	  Jeff

Does this mean that I cannot mmap() address zero in the kernel
anymore? I should be able (in the kernel) read anything, and
then mmap() it to something usable in user-space. If address
zero is now artifically trapped there are problems being created
for no good reason at all.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
