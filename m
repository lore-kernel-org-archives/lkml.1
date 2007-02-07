Return-Path: <linux-kernel-owner+w=401wt.eu-S965683AbXBGQrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965683AbXBGQrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965684AbXBGQrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:47:23 -0500
Received: from mail14.messagelabs.com ([212.125.75.19]:45898 "HELO
	mail14.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965683AbXBGQrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:47:22 -0500
X-VirusChecked: Checked
X-Env-Sender: martyn.welch@radstone.co.uk
X-Msg-Ref: server-5.tower-14.messagelabs.com!1170866840!88643!1
X-StarScan-Version: 5.5.10.7.1; banners=radstone.co.uk,-,-
X-Originating-IP: [193.130.116.242]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: alloc_bootmem - Kernel panic
Date: Wed, 7 Feb 2007 16:47:20 -0000
Message-ID: <F38DEABE0E171746B133C1ABBD142D9706325502@radmail.Radstone.Local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: alloc_bootmem - Kernel panic
Thread-Index: AcdKygIyKyLLVSoWR5yMmxWxq/nG1QACjIBg
From: "Martyn Welch" <martyn.welch@radstone.co.uk>
To: "Asgard" <dubalom@gmail.com>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Asgard,

Thank you for your reply.
	
> I don't sure, that linux performs to allocate bootmem after kernel already booted.
> As I know, bootmem allocator "destroyed" when kernel initializes buddy allocator.
> Indeed you can look at arch/i385/mm/init.c, mem_init routine.
> kernel passes all bootmem pages to buddy system, so bootmem allocator can't be used after it. 
	
That explains why I can't use alloc_bootmem. It'd assumed that do_initcalls and hence functions labelled with module_init() were called early enough, mainly because LDD3 suggests using alloc_bootmem. It seems the vt driver uses console_init() instead, which is called much earlier.

Which leads me to the question: what is the best method to reserve a large (~4MB) coherent buffer for DMA transfers?

Is there any way of using alloc_bootmem from a driver (compiled into the kernel) without delving further into kernel code?

Martyn

________________________________________________________________________
This e-mail has been scanned for all viruses by Star.The service is powered by MessageLabs. 
________________________________________________________________________
