Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbZD0JJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbZD0JJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZD0JJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:09:20 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:62412 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZD0JJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:09:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] fsldma: use PCI Read Multiple command
Date: Mon, 27 Apr 2009 17:09:13 +0800
Message-ID: <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>
In-Reply-To: <20090424183517.GB23140@ovro.caltech.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsldma: use PCI Read Multiple command
Thread-Index: AcnFC64fztqaY+DAQ5aCj0/qmZUiqwCCrMqw
References: <20090424183517.GB23140@ovro.caltech.edu>
From: "Liu Dave-R63238" <DaveLiu@freescale.com>
To: "Ira Snyder" <iws@ovro.caltech.edu>, <linux-kernel@vger.kernel.org>
Cc: <linuxppc-dev@ozlabs.org>, "Dan Williams" <dan.j.williams@intel.com>,
       "Li Yang-R58472" <LeoLi@freescale.com>,
       "Zhang Wei" <wei.zhang@freescale.com>
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> By default, the Freescale 83xx DMA controller uses the PCI Read Line
> command when reading data over the PCI bus. Setting the 
> controller to use the PCI Read Multiple command instead allows the
> controller to read much larger bursts of data, which provides a
drastic
> speed increase.

IIRC, the default for 83xx DMA controller uses the PCI mem read
command, not mem read line.

You are assuming the PCI memory space is prefetchable( no side effect)
for DMA.
Is it possible that DMA is from non-prefetchable memory space?

> The slowdown due to using PCI Read Line was only observed 
> when a PCI-to-PCI bridge was between the devices trying to
communicate.
> 
> A simple test driver showed an increase from 4MB/sec to 116MB/sec when
> performing DMA over the PCI bus. Using DMA to transfer between blocks
> of local SDRAM showed no change in performance with this patch. 
> The dmatest driver was also used to verify the correctness of the
transfers,
> and showed no errors.
