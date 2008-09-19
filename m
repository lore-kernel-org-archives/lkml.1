Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYISOu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYISOu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYISOut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:50:49 -0400
Received: from mail91.analogic.com ([208.224.220.31]:49240 "EHLO
	mail01.analogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752764AbYISOus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:50:48 -0400
X-AuditID: 0a770115-ac680bb0000014a6-27-48d3bc47e122
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 19 Sep 2008 14:50:26.0669 (UTC) FILETIME=[0D77F9D0:01C91A67]
Content-class: urn:content-classes:message
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Date: Fri, 19 Sep 2008 10:50:26 -0400
Message-ID: <Pine.LNX.4.61.0809191042020.11905@chaos.analogic.com>
In-Reply-To: <48D3B880.3070607@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: dmaengine.c: question about device_alloc_chan_resources
Thread-Index: AckaZw1/t4hh8Tp0RgOwcsF7ZKUCMA==
References: <48D02589.8070601@freescale.com> <e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com> <ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com> <20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com> <48D2664D.7040204@freescale.com> <20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com> <e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com> <20080919132544.533ab7d0@hskinnemo-gx745.norway.atmel.com> <48D3B880.3070607@freescale.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Timur Tabi" <timur@freescale.com>
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Dan Williams" <dan.j.williams@intel.com>,
       "lkml" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008, Timur Tabi wrote:

> Haavard Skinnemoen wrote:
>
>> Yes, or maybe provide an interface for simply requesting a channel
>> without having to register any callbacks.
>
> I could use this feature.  The sound drivers for our MPC8610 processor use DMA,
> but the drivers need to control the DMA hardware directly, so I can't use
> dmaengine.  I would like to be able to just reserve the channels and program
> them as I see fit.
>
> -- 
> Timur Tabi
> Linux kernel developer at Freescale

The hardware on the PC/AT machines won't allow you to
reserve a specific channel and program it as you see fit,
because there are two devices, one for the low DMA
channels and another for the high ones. Even the low
DMA device has a channel in use as a cascade so, if
you were to touch any of its registers while a DMA
was in progress, the result will be undefined. That's
why there needs to be a central procedure to handle
this shared resource and why drivers need to interface
through it and not touch the hardware. Bus Master
DMA from PCI boards is an entirely different matter.
Nobody but the driver for the board is going to muck
with its DMA so it does not need to be protected as a
shared resource.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4786.70 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged. Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
