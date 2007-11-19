Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbXKSJW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbXKSJW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbXKSJWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:22:49 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:55401 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXKSJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:22:48 -0500
Message-ID: <1195464075.4741558b0f3c6@imp.free.fr>
Date: Mon, 19 Nov 2007 10:21:15 +0100
From: eg.news@free.fr
To: linux-kernel@vger.kernel.org
Subject: Huge DMA feasibility with linux 2.6.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 77.104.18.126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Before to post you this request, I have read J BOTTOMLEY documentation
(inside kernel doc and linux journal).
May be I have not understood but I currently have the following
problem.

DESCRIPTION
------------------
On a PC (x86_64 SMP using linux kernel 2.6.17) there is a device
dedicated to data acquisition linked via a PCIe bus (using 4 PCIe x4
slots), this device has 2GB of memory.

We need to perform huge DMA transfer (from the device to the PC) using
16 PCIe lanes, on the PC side the resulting buffer can be 480 MB long
(each lane transferring 30 MB).
Because of ping-pong (2 buffers available for the same acquisition)
and multi-modality (several kind of data acquired), the total aperture
accessible by DMA can reach 1.6 GB.
The datarate has to be greater than 180MB/s per lane ( 2,8 GB/s for
the whole device).

To reach that datarate we plan to make the device initiate the
transfer and use local Scatter Gather List.

QUESTIONS
---------------
At this point we have the following questions
Q1: It is possible to get the private usage of these 1.6GB of memory
for the DMA (by getting it out of the memory managed by linux)?
Q1.1 : If yes what are the ways ?
Q1.2 : Is kernel function "init_memory_mapping" a way to get that
(according to arch/x86_64/kernel/setup.c:643) ?
Q2: Otherwise do we only have to reserve pages in DMA32 zone during
the early bootup stage?
Q3 :  Other solutions?

Any help is welcome

THX
Eric Guiffard



