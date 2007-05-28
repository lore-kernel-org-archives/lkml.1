Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbXE1BP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbXE1BP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759044AbXE1BPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:15:51 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:58345 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbXE1BPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:15:50 -0400
X-IronPort-AV: i="4.14,585,1170662400"; 
   d="scan'208"; a="158013329:sNHT42844374"
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Greg KH <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
X-Message-Flag: Warning: May contain useful information
References: <20070523155958.GA5282@kroah.com> <4654AB40.6060208@gmail.com>
	<adaejl79rh0.fsf@cisco.com> <4654BC10.2000808@gmail.com>
	<adazm3v89hv.fsf@cisco.com> <4654C85B.6060505@gmail.com>
	<adatzu385g1.fsf@cisco.com> <46561287.8020103@gmail.com>
	<ada1wh560u1.fsf@cisco.com> <46584C30.4030206@gmail.com>
	<20070526182828.GA7080@colo.lackof.org> <46588A3D.2060208@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 27 May 2007 18:15:49 -0700
In-Reply-To: <46588A3D.2060208@gmail.com> (Manu Abraham's message of "Sat, 26 May 2007 23:27:57 +0400")
Message-ID: <adaps4l21fe.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 May 2007 01:15:49.0362 (UTC) FILETIME=[BA0ACD20:01C7A0C5]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > >> Another question would be if the device supports multiple messages, MSIX
 > >> should be used ?
 > > 
 > > Yes. Assuming the device supports multiple MSI-X messages.

At least on my device (PCI ID 1131:7162) there is no MSI-X capability,
so that's not an option for you.  The current Linux implementation
does not support more than one MSI interrupt, so you just get one
interrupt with pci_enable_msi().

I think it's probably simplest for you to forget about MSI until you
have the basic driver working.

 > Ok. Alongwith this, i am a bit confused with the mailbox approach of
 > sending messages, every register type has it's own set of interrupt
 > registers (for example I2C, say I2C has it's own set of 32 STATUS
 > bitfields for it's interrupt, the same goes for the others)
 > 
 > Another aspect is the DTL-MMIO interface, which isn't defined any place.
 > Using the base addresses as an offset to the normal MMIO obtained using
 > pci_resource_*/ioremap() doesn't seem to work at all.

 > [etc....]

All this is device-specific stuff ... not sure how much anyone can
help you if you can't share the docs.

 - R.
