Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbXE1BF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbXE1BF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbXE1BFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:05:50 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:44721 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbXE1BFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:05:49 -0400
X-IronPort-AV: i="4.14,585,1170662400"; 
   d="scan'208"; a="158011906:sNHT40657293"
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, abraham.manu@gmail.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
X-Message-Flag: Warning: May contain useful information
References: <46561287.8020103@gmail.com> <ada1wh560u1.fsf@cisco.com>
	<46584C30.4030206@gmail.com>
	<20070526.154910.78725926.davem@davemloft.net>
	<4658EE32.5080506@zytor.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 27 May 2007 18:05:43 -0700
In-Reply-To: <4658EE32.5080506@zytor.com> (H. Peter Anvin's message of "Sat, 26 May 2007 19:34:26 -0700")
Message-ID: <aday7j921w8.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 May 2007 01:05:43.0316 (UTC) FILETIME=[50CF8540:01C7A0C4]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Presumably we need something like IRQF_MSI which can be set as
 > appropriate depending on the architecture?

Unfortunately I don't think it's that simple -- drivers would have to
do something like

	if (IRQF_MSI == IRQF_SHARED) {
		// lose MSI optimizations, do an MMIO read, etc.
	} else...

As I said I think that if we're running on a system where MSI
interrupts might be shared, we should just have pci_enable_msi() fail
so drivers fall back to their usual interrupt handler.
