Return-Path: <linux-kernel-owner+w=401wt.eu-S934944AbXJOU0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944AbXJOU0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934552AbXJOUZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:25:53 -0400
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:49573 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764223AbXJOUZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:25:51 -0400
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch
Date: Mon, 15 Oct 2007 20:24:48 -0000
Message-ID: <66ED1F0546CFFE4BABB226CD6633D4A6015F7723@G3W0635.americas.hpqcorp.net>
In-reply-to: <20071015111553.1b8e6125@laptopd505.fenrus.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch
Thread-index: AcgPV7vEQksby/NCThWZ1XbkkM2cBAAD2Snw
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Oct 2007 20:24:49.0377 (UTC) FILETIME=[6F534510:01C80F69]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This could be done but then it adds complexity to the patch (as now two
different parts of the kernel need to be modified) and requires
regression testing for multiple platforms and OEM's.

This patch is isolated similar to the other HW specific HW Watchdog
Timers and yet provides a common Linux user interface that is applicable
across all OEM platforms that choose to implement a HW watchdog timer
device driver.

We chose to keep the changes isolated at this time to gain quick
acceptance upstream. 

-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Monday, October 15, 2007 1:16 PM
To: Mingarelli, Thomas
Cc: linux-kernel@vger.kernel.org; Mingarelli, Thomas
Subject: Re: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch

On Mon, 15 Oct 2007 14:05:50 -0400 (EDT) thomas.mingarelli@hp.com wrote:

> Hp is providing a Hardware WatchDog Timer driver that will only work 
> with the specific HW Timer located in the HP ProLiant iLO 2 ASIC. The 
> iLO 2 HW Timer will generate a Non-maskable Interrupt (NMI) 9 seconds 
> before physically resetting the server, by removing power, so that the

> event can be logged to the HP Integrated Management Log (IML), a 
> Non-Volatile Random Access Memory (NVRAM). The logging of the event is

> performed using the HP ProLiant ROM via an Industry Standard access 
> known as a BIOS Service Directory Entry.


Hi,

Your patch looks quite clean in general; however it does make me wonder
if it should either leverage or expand the arch/x86/pci/pcbios.c
infrastructure for doing BIOS32 calls and share that.... it's kinda
unpleasant as a general thought to have drivers poke this deep into
various guts of the system/bios.... esp if the common code has to do
something very similar already.

Greetings,
   Arjan van de Ven
