Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbXHAGOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbXHAGOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbXHAGOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:14:06 -0400
Received: from rrzmta1.rz.uni-regensburg.de ([194.94.155.51]:26402 "EHLO
	rrzmta1.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbXHAGOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:14:04 -0400
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaet Regensburg, Klinikum
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Wed, 01 Aug 2007 08:13:48 +0200
MIME-Version: 1.0
Subject: Re: Q: PCI-X @ 266MHz on HP rx6600 (Qlogic 4Gb FC HBA)
CC: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       linux-kernel@vger.kernel.org
Message-ID: <46B040BB.8979.A674628@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-reply-to: <20070731165003.GF8842@plap.qlogic.org>
References: <20070727161120.GB20540@plap.qlogic.org>
X-mailer: Pegasus Mail for Windows (4.31)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.25/Sophos-P=4.19.0+V=4.19+U=2.07.173+R=02 July 2007+T=258977@20070801.060947Z
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 Jul 2007 at 9:50, Andrew Vasquez wrote:

> > On Fri, 27 Jul 2007, Andrew Patterson wrote:
> > 
> > > On Thu, 2007-07-26 at 23:23 -0700, Andrew Vasquez wrote:
> > >
> > > > The 33/66/100/133 values refer to the bus-clock speed at which the
> > > > card is operating.  As is seen here (although a bit truncated --
> > > > separate issue, I'll try to see if I can reproduce this on one of my
> > > > HPQ rigs), the card is inserted into a PCI-X Mode-2 capable 133MHz
> > > > (bus clock) slot.  When operating under this mode, each data-phase
> > > > between two devices is divided into 2 sub-phases, effectively doubling
> > > > the transfer-data-rate to 266Mhz.
> > > 
> > > I guess the proper terminology would be 266 MT/s (Mega
> > > Transfers/second). Looking through the PSI_SIG PCI-X 2.0 marketing
> > > blurbs, they use MHz a lot when referring to MT/S. So I would still
> > > consider this to be a minor bug.  The user wants to know the transfer
> > > rate, not the actual frequency of the bus.  Maybe just print out the
> > > mode used instead, e.g., "PCI-X 266"?
> 
> Given PCI-X Mode-2 can run at different bus-clock speeds, how about
> this as an alternative?
> 
> 	PCI-X 266 (133Mhz)

To pick up the idea, why not "133" and "133x2" (DDR, Dual Data Rate)?

> 
> it's a bit more descriptive than
> 
> 	PCI-X Mode 2 (133Mhz)
> 
> then again, I don't want to beat this thing to death...
> 
> ---
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c488996..26f7e54 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -283,9 +283,9 @@ qla24xx_pci_info_str(struct scsi_qla_host *ha, char *str)
>  	} else {
>  		strcat(str, "-X ");
>  		if (pci_bus & BIT_2)
> -			strcat(str, "Mode 2");
> +			strcat(str, "266");
>  		else
> -			strcat(str, "Mode 1");
> +			strcat(str, "133");
>  		strcat(str, " (");
>  		strcat(str, pci_bus_modes[pci_bus & ~BIT_2]);
>  	}


