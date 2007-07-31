Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbXGaQuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbXGaQuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761842AbXGaQuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:50:08 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:36665 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764506AbXGaQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:50:06 -0400
Date: Tue, 31 Jul 2007 09:50:03 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: PCI-X @ 266MHz on HP rx6600 (Qlogic 4Gb FC HBA)
Message-ID: <20070731165003.GF8842@plap.qlogic.org>
References: <46A8BF75.161.5C8424A@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de> <1185487419.7134.485.camel@bluto.andrew> <20070727062343.GC15408@plap.qlogic.org> <1185551189.7134.501.camel@bluto.andrew> <20070727161120.GB20540@plap.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727161120.GB20540@plap.qlogic.org>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 31 Jul 2007 16:49:10.0828 (UTC) FILETIME=[B7F45EC0:01C7D392]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 27 Jul 2007, Andrew Patterson wrote:
> 
> > On Thu, 2007-07-26 at 23:23 -0700, Andrew Vasquez wrote:
> >
> > > The 33/66/100/133 values refer to the bus-clock speed at which the
> > > card is operating.  As is seen here (although a bit truncated --
> > > separate issue, I'll try to see if I can reproduce this on one of my
> > > HPQ rigs), the card is inserted into a PCI-X Mode-2 capable 133MHz
> > > (bus clock) slot.  When operating under this mode, each data-phase
> > > between two devices is divided into 2 sub-phases, effectively doubling
> > > the transfer-data-rate to 266Mhz.
> > 
> > I guess the proper terminology would be 266 MT/s (Mega
> > Transfers/second). Looking through the PSI_SIG PCI-X 2.0 marketing
> > blurbs, they use MHz a lot when referring to MT/S. So I would still
> > consider this to be a minor bug.  The user wants to know the transfer
> > rate, not the actual frequency of the bus.  Maybe just print out the
> > mode used instead, e.g., "PCI-X 266"?

Given PCI-X Mode-2 can run at different bus-clock speeds, how about
this as an alternative?

	PCI-X 266 (133Mhz)

it's a bit more descriptive than

	PCI-X Mode 2 (133Mhz)

then again, I don't want to beat this thing to death...

---

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c488996..26f7e54 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -283,9 +283,9 @@ qla24xx_pci_info_str(struct scsi_qla_host *ha, char *str)
 	} else {
 		strcat(str, "-X ");
 		if (pci_bus & BIT_2)
-			strcat(str, "Mode 2");
+			strcat(str, "266");
 		else
-			strcat(str, "Mode 1");
+			strcat(str, "133");
 		strcat(str, " (");
 		strcat(str, pci_bus_modes[pci_bus & ~BIT_2]);
 	}
