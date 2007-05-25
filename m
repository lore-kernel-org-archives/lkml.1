Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbXEYD0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbXEYD0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 23:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXEYD0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 23:26:01 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:36537 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbXEYD0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 23:26:00 -0400
X-IronPort-AV: i="4.14,577,1170662400"; 
   d="scan'208"; a="157363878:sNHT41329287"
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
X-Message-Flag: Warning: May contain useful information
References: <46543045.3030904@gmail.com> <20070523155958.GA5282@kroah.com>
	<4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com>
	<4654BC10.2000808@gmail.com> <adazm3v89hv.fsf@cisco.com>
	<4654C85B.6060505@gmail.com> <adatzu385g1.fsf@cisco.com>
	<46561287.8020103@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 May 2007 20:25:58 -0700
In-Reply-To: <46561287.8020103@gmail.com> (Manu Abraham's message of "Fri, 25 May 2007 02:32:39 +0400")
Message-ID: <ada1wh560u1.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 May 2007 03:25:58.0555 (UTC) FILETIME=[6971D6B0:01C79E7C]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I am now wondering whether the usage of MSI would help in this case and
 > that i should be using enable_msi before request_irq ?

MSI interrupts are never shared.  So if pci_enable_msi() succeeds, you
can be sure that the interrupts you get with that IRQ number are
coming from your device.

But using MSI does not work on all systems, so your driver needs to
work with standard (possibly shared) INTx interrupts too.  And you
should probably provide at least a module flag to disable the use of
MSI, to avoid problems on buggy systems.

 - R.
