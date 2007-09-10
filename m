Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbXIJSFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbXIJSFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 14:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750700AbXIJSFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 14:05:44 -0400
Received: from spirit.analogic.com ([204.178.40.4]:2913 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXIJSFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 14:05:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 10 Sep 2007 18:05:07.0931 (UTC) FILETIME=[1F22DAB0:01C7F3D5]
Content-class: urn:content-classes:message
Subject: Re: ECC and DMA to/from disk controllers
Date: Mon, 10 Sep 2007 14:05:39 -0400
Message-ID: <Pine.LNX.4.61.0709101346030.32415@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.63.0709100707210.28162@trinity.phys.uwm.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ECC and DMA to/from disk controllers
Thread-Index: Acfz1R8ubZObwwBLRp6uisq5fAhsfQ==
References: <Pine.LNX.4.63.0709100707210.28162@trinity.phys.uwm.edu>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Bruce Allen" <ballen@gravity.phys.uwm.edu>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bruce Allen" <bruce.allen@aei.mpg.de>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 10 Sep 2007, Bruce Allen wrote:

> Dear LKML,
>
> Apologies in advance for potential mis-use of LKML, but I don't know where
> else to ask.
>
> An ongoing study on datasets of several Petabytes have shown that there
> can be 'silent data corruption' at rates much larger than one might
> naively expect from the expected error rates in RAID arrays and the
> expected probability of single bit uncorrected errors in hard disks.
>
> The origin of this data corruption is still unknown.  See for example
> http://cern.ch/Peter.Kelemen/talk/2007/kelemen-2007-C5-Silent_Corruptions.pdf
>
> In thinking about this, I began to wonder about the following.  Suppose
> that a (possibly RAID) disk controller correctly reads data from disk and
> has correct data in the controller memory and buffers.  However when that
> data is DMA'd into system memory some errors occur (cosmic rays,
> electrical noise, etc).  Am I correct that these errors would NOT be
> detected, even on a 'reliable' server with ECC memory?  In other words the
> ECC bits would be calculated in server memory based on incorrect data from
> the disk.
>
> The alternative is that disk controllers (or at least ones that are meant
> to be reliable) DMA both the data AND the ECC byte into system memory.
> So that if an error occurs in this transfer, then it would most likely be
> picked up and corrected by the ECC mechanism.  But I don't think that
> 'this is how it works'.  Could someone knowledgable please confirm or
> contradict?
>
> Cheers,
> 	Bruce
> -

In a typical system, there are usually hardware data transfer
paths that are not under the protection of any ECC mechanism.
One example is "bus mastering" DMA itself. If the bus-interface
state-machine is improperly designed (read timing problems), data
transfer may be unreliable. Of course serial-ATA, SCSI, and
other external buses have a modicum of protection, but early
IDE did not. There are many file-systems that have been corrupted
by incorrect cables, bad motherboard or chip designs, or using
UDMA when the hardware won't reliably work.

That said, the reliability of data transfer buses is pretty
good because they don't need to store data for long periods
of time, like RAM. The probability of a bit upset due to
a nuclear event is highly unlikely in a bus where something
is driving the bus, keeping the data valid, during the time
that something else is reading the bus. Nuclear events
generally upset RAM because the data are stored in very
small charges and femtoamperes of spurious current can
alter logic states.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
