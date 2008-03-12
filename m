Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYCLC3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYCLC3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYCLC25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:28:57 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:58004 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbYCLC24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:28:56 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 2/2] Add device_prep_dma_interrupt support to fsldma.c
Date: Wed, 12 Mar 2008 10:28:49 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AECE527E@zch01exm26.fsl.freescale.net>
In-Reply-To: <e9c3a7c20803111455g354741f0sff7d4fc0172dc65e@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] Add device_prep_dma_interrupt support to fsldma.c
Thread-Index: AciDwqKwKblje3mXSA6S13WXe3U1LgAJBEKQ
References: <1205205917-21861-1-git-send-email-wei.zhang@freescale.com> <1205205917-21861-2-git-send-email-wei.zhang@freescale.com> <e9c3a7c20803111455g354741f0sff7d4fc0172dc65e@mail.gmail.com>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan, 

> -----Original Message-----
> From: dan.j.williams@gmail.com 
> >  +
> >  +       /* Set End-of-link to the last link descriptor of 
> new list*/
> >  +       set_ld_eol(fsl_chan, new);
> 
> Question, is 'set_ld_eol' safe to call on descriptors that may not be
> the last in the list?  For example what about the following sequence:

set_ld_eol() is a safe function, which is only for preparing the tx descriptors
lists. When adding prepared tx descriptior list to DMA channel tx list,
the function append_ld_queue() should be called.

> 
> /* prepare two descriptors */
> tx1 = fsl_dma_prep_interrupt(chan);
> tx2 = fsl_dma_prep_memcpy(chan);
> 
> /* submit out of order */
> tx2->tx_submit(tx2);
> tx1->tx_submit(tx1);
> 
> This is only a concern if you plan to support channel switching at
> some point.  For example, switching from a memcpy channel to an xor
> channel.
> 
It's no problem. :) In fact, I've added out of order testing codes in fsl_dma_self_test()
 function.

But I have a question about device_prep_dma_interrupt(), which is no way to assign
 dest and src address. Is it a null tx action dma_async_tx_descriptor except to trigger
 an interrupt?

Thanks!
Wei.
