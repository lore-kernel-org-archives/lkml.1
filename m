Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbZD1BtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbZD1BtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbZD1BtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:49:09 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:56607 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZD1BtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:49:07 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] fsldma: use PCI Read Multiple command
Date: Tue, 28 Apr 2009 09:48:58 +0800
Message-ID: <D7CCA83BB0796C49BC0BB53B6AB1208928CABC@zch01exm21.fsl.freescale.net>
In-Reply-To: <49F608B7.9080409@ovro.caltech.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsldma: use PCI Read Multiple command
Thread-Index: AcnHb0Tk8Z1RdEKzT6q9dGfnC8niAgAMwnbw
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu>
From: "Liu Dave-R63238" <DaveLiu@freescale.com>
To: "David Hawkins" <dwh@ovro.caltech.edu>,
       "Tabi Timur-B04825" <timur@freescale.com>
Cc: "Ira Snyder" <iws@ovro.caltech.edu>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>, "Dan Williams" <dan.j.williams@intel.com>,
       "Zhang Wei" <wei.zhang@freescale.com>
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a few results from DMA tests between two
> MPC8349EA boards housed in a CPCI chassis.
> 
> 1. DMA mode register (DMAMRn)
>     PCI read command (PRC, bits 11:10)
> 
>     a) DMAMRn[PRC] = 00 = PCI Read
> 
>        The PCI read command is 6h on the PCI bus.
>        For DMA lengths of less than 1 cache line (32-bytes)
>        the DMA controller will generate a PCI 6h command.
>        However, for lengths of 32-bytes and higher, the
>        DMA controller actually generates a PCI Read Line (Eh)
>        command.
> 
>        Freescale indicated that this 'change of PCI command code'
>        functionality is an undocumented 'feature', there to
>        improve performance for longer read lengths.
> 
>     b) DMAMRn[PRC] = 01 = PCI Read Line
> 
>        Generated the PCI command code for PCI read line (Eh),
>        regardless of DMA length.
> 
>     c) DMAMRn[PRC] = 10 = PCI Read Multiple
> 
>        Generated the PCI command code for PCI Read Multiple (Ch),
>        regardless of DMA length.

Good summary!

For the DMA PCI read/line/multi-line is outbound transaction.
So according to your experiment, the 8349 PCI controller(as master)
attemp to streaming/combining the outbound transaction(treated as
prefetchable
space). 
IIRC, the early 8349EUM has the bit[2]-SE in the POCMRn
register, and is removed now. Not sure if it does function.
