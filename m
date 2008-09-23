Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYIWOEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYIWOEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYIWODv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:03:51 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:45224 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYIWODv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:03:51 -0400
Message-ID: <48D8F73A.4050004@freescale.com>
Date: Tue, 23 Sep 2008 09:03:38 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Ira Snyder <iws@ovro.caltech.edu>
CC: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, leoli@freescale.com, zw@zh-kernel.org,
       Kumar Gala <kumar.gala@freescale.com>
Subject: Re: Problems with Freescale DMA driver
References: <20080825165133.GA20446@ovro.caltech.edu> <e9c3a7c20809181458p4cabccblfde6a92bf35976ee@mail.gmail.com> <48D2D00B.3010001@freescale.com> <20080922230435.GA20825@ovro.caltech.edu>
In-Reply-To: <20080922230435.GA20825@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ira Snyder wrote:

> When your patch makes it in, you should probably add the cell-index to
> all of the dts files that are missing them.

Ah, I see that Kumar added a bunch of DMA nodes back in June and forgot the
cell-index properties.

> I was not able to cause the DMA controller to copy bad data. Perhaps the
> kernel just had a bug at the time. It was still relatively early on in
> the development cycle.

dmatest runs all the time, so it's possible that it's eating up DMA resources.
Try running your tests without CONFIG_DMATEST.

> In a related note, I've been somewhat following the discussion on LKML
> about creating an API for requesting a single DMA channel. This would be
> great in a driver I've written for PCI communication over a backplane.
> (I have a test board running in PCI Agent mode. It creates a virtual
> ethernet interface that passes data over the PCI bus.)

PCI devices should not be using generic DMA resources, so I don't see how this
would apply.

> Also, are there any plans to support the external start feature on the
> 83XX parts? (According to my datasheet, it is supported.) I will be
> using this feature in a driver I will be starting fairly soon.

External start is very device-specific, so I don't see how a generic DMA driver,
which is intended only for memory-to-memory DMA operations, can coordinate with
an external master.

-- 
Timur Tabi
Linux kernel developer at Freescale
