Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbYFITms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbYFITms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYFITmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:42:40 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:36347 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYFITmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:42:39 -0400
X-IronPort-AV: E=Sophos;i="4.27,613,1204531200"; 
   d="scan'208";a="39789145"
From: Roland Dreier <rdreier@cisco.com>
To: "Meyers\, Jordan" <Jordan_Meyers@cable.comcast.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Can Linux control PCIe Transaction Layer Packet creation, when writing to a region pointed to by Base Address Register
References: <38F5F6E4D905F142BAA734B9D894F12407634DB1@CAPLSEXCMB01.cable.comcast.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 09 Jun 2008 12:42:38 -0700
In-Reply-To: <38F5F6E4D905F142BAA734B9D894F12407634DB1@CAPLSEXCMB01.cable.comcast.com>
	(Jordan Meyers's message of "Mon, 9 Jun 2008 12:13:21 -0700")
Message-ID: <adaprqq8kep.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jun 2008 19:42:38.0650 (UTC) FILETIME=[F93579A0:01C8CA68]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Any thoughts or suggestions of how to ensure a buffer's data is
 > transferred from the driver to the PCIe card in a single TLP (where
 > the intended payload size is less than the max payload value in
 > Device Control register of the PCI register space)?

If you are doing MMIO (memory-mapped IO, that is, the CPU is using write
operations to write to a memory-mapped PCI BAR), then you probably
cannot ensure that the data goes into a single PCIe packet.  I think the
best you can do is map the PCI memory into the CPU's address space with
write combining (WC) enabled (see ioremap_wc() in recent kernels), which
is likely to generate larger bursts if possible.

 - R.
