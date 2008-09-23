Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbYIWQK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbYIWQK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYIWQKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:10:17 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:43506 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYIWQKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:10:16 -0400
Message-ID: <48D914DD.7080702@freescale.com>
Date: Tue, 23 Sep 2008 11:10:05 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Ira Snyder <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems with Freescale DMA driver
References: <20080825165133.GA20446@ovro.caltech.edu> <e9c3a7c20809181458p4cabccblfde6a92bf35976ee@mail.gmail.com> <48D2D00B.3010001@freescale.com> <20080922230435.GA20825@ovro.caltech.edu> <48D8F73A.4050004@freescale.com> <20080923155935.GA7449@ovro.caltech.edu>
In-Reply-To: <20080923155935.GA7449@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Removing various CC:'s since this thread is changing topic)

Ira Snyder wrote:

> I hope that makes sense. I can post the code if anyone would like to see
> it. It is not ready for mainline inclusion yet, but it is in a fairly
> good state.

Well, it's a bit goofy, but it does make sense.  Since you don't have an actual
single-function PCI device, you need to use the MPC8349's DMA controller.

I don't see where you need the ability to reserve a DMA channel, though.  You're
using fsldma.c as its intended.

> Ok. I was just wondering, since drivers/dma/fsl_dma.c has some code that
> appears to handle external master. It is 85XX specific though. There are
> no users in the kernel tree showing example uses.

Indeed it does.  It looks like a feature that was thrown in but never given much
thought or testing.  It appears that the current code just lets you turn on the
external master pause bit in the MR register, but there's nothing to make sure
that it actually works in a meaningful way.  If there's a queue of transfers for
a given channel, I don't see where the fsldma avoids stalled queues.

-- 
Timur Tabi
Linux kernel developer at Freescale
