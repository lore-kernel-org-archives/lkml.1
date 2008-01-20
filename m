Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYATQbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYATQbw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYATQbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:31:45 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48651 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbYATQbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:31:44 -0500
Date: Sun, 20 Jan 2008 16:31:42 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, mingo@elte.hu
Subject: Re: 2.6.24-rc8-mm1
Message-ID: <20080120163141.GA10097@csn.ul.ie>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (17/01/08 02:35), Andrew Morton didst pronounce:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 

The e100 network driver is failing to load properly on an old laptop. The
dmesg output is as follows

[   68.875508] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   68.877091] e100: Copyright(c) 1999-2006 Intel Corporation
[   68.881216] ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
[   68.893113] modprobe:2736 conflicting cache attribute e8120000-e8121000 uncached<->default
[   68.897090] e100: 0000:00:03.0: e100_probe: Cannot map device registers, aborting.
[   68.901108] ACPI: PCI interrupt for device 0000:00:03.0 disabled
[   68.905106] e100: probe of 0000:00:03.0 failed with error -12

The "conflicting cache attribute" message appears to be part of the PAT patches
in the git-x86 tree (cc's added). It may be a co-incidence but reverting
git-net related patches didn't fix it but reverting git-x86 and any
depencies to make quilt work did.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
