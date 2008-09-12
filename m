Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbYILOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbYILOtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYILOtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:49:09 -0400
Received: from spirit.analogic.com ([204.178.40.4]:3644 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYILOtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:49:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 12 Sep 2008 14:45:44.0534 (UTC) FILETIME=[3C695760:01C914E6]
Content-class: urn:content-classes:message
Subject: Re: Building Kernel with -O0
Date: Fri, 12 Sep 2008 10:45:43 -0400
Message-ID: <Pine.LNX.4.61.0809121035390.7493@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0809120918570.7332@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Building Kernel with -O0
Thread-Index: AckU5jyNd58rcpnlTTe/ejcNqLD+Vg==
References: <b8rB2-6BM-1@gated-at.bofh.it> <badXc-7gl-21@gated-at.bofh.it> <baf2M-bE-7@gated-at.bofh.it> <bagBJ-20J-7@gated-at.bofh.it> <E1KdOFZ-0001Q4-So@be1.7eggert.dyndns.org> <2cf1ee820809112221w213aa929x32905e1c25897cf3@mail.gmail.com> <Pine.LNX.4.61.0809120918570.7332@chaos.analogic.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "emin ak" <eminak71@gmail.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 12 Sep 2008, linux-os (Dick Johnson) wrote:

>
> On Fri, 12 Sep 2008, emin ak wrote:
>
>> 2008/9/10 Bodo Eggert <7eggert@gmx.de>:
>>> linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>>>
>>>> If you have to single-step through kernel procedures, you
>>>> are not writing proper code for a kernel. Furthermore, even
>>>> when using the kernel debugger, you are not executing the
>>>> exact same path that would be executed without the debugger
>>>> attached.
>>>
>>> I sometimes single-step in order to verify my (userspace) code, instead of
>>> just throwing random test data at it. It's easier and makes me feel better.
>>> OTOH, -O2 never was a problem if I used it, so I don't strongly vote
>>> for enabling -O0.
>>>

Let me steal a bit of bandwidth and explain what
I mean about writing kernel code.

What is often lost to new people who want to develop
kernel code is that you can write and test many
pieces of kernel code within a "friendly" user-mode
environment.

Suppose you need to write a driver for a complex
I/O subsystem that is accessed over the PCI bus.

This seems difficult until you understand that the
starting piece of code will be something to find
your device and access its registers. This can
usually be (mostly) copied from another existing
driver.

Once its memory-mapped registers have been
uncovered, you can implement mmap() in your
driver and then access them from a user-space
program you write, reading/writing setting
bits and observing the hardware behavior
well before you write actual driver code.
Parts of the code that you develop in user-
space will eventually be cut and pasted
into your kernel driver code.

You are not going to be able to write your
interrupt service routines in user-mode but
they can still be in your driver code in which
you implemented mmap(). They just do a printk()
and attempt to reset your hardware for the next
interrupt. If it doesn't work, you can experiment
in user-mode, writing to registers, until you
have satisfied the hardware so the next interrupt
will properly occur.

If you write drivers in this manner, you will not
have code that doesn't work in the kernel code. It
may not work exactly as you want, but it will work
well enough so that a few printks will allow you
to get its real-time operation working as expected.

Warning! Do NOT leave hardware registers exposed to
user-mode access like Windows does. Your initial memory-
mapping was to help develop kernel code, not to create
a user-mode driver! Such code would be called a "layering
violation..."


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4786.38 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
