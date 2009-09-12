Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZILARv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZILARv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 20:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbZILARu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 20:17:50 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:39881 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175AbZILARt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 20:17:49 -0400
Date: Fri, 11 Sep 2009 17:17:52 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: qla2xxx: Correct compilation issues when CONFIG_MOUDLES=n
 (was: Re: linux-next: Tree for September 7 (scsi/qla2x))
Message-ID: <20090912001752.GC12098@plap4-2.local>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
 <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
 <20090908182541.GB44157@plap4-2.local>
 <20090911175341.GH710@plap4-2.local>
 <1252708951.13282.151.camel@mulgrave.site>
 <20090912000742.GB12098@plap4-2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912000742.GB12098@plap4-2.local>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 Sep 2009 00:17:22.0288 (UTC) FILETIME=[65D44700:01CA333E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009, Andrew Vasquez wrote:

> The struct device's kobj from pdev->dev?
> 
> My udev-foo is pathetic, so how exactly would that get multiplexed at
> the udev side?
> 
> 	KERNEL=="???", SUBSYSTEM=="???", ACTION=="change", RUN+="qla2xxx_udev.sh"

Ok, udevadm helps a bit...  Let me see if I can convert this uevent
off of:

	kobject_uevent_env(&(&vha->hw->pdev->dev)->kobj, KOBJ_CHANGE, envp);

to something meaningful:

	UEVENT[1252714722.263731] change
	/devices/pci0000:17/0000:17:08.0/0000:1e:00.0 (pci)
	ACTION=change
	DEVPATH=/devices/pci0000:17/0000:17:08.0/0000:1e:00.0
	SUBSYSTEM=pci
	FW_DUMP=6
	DRIVER=qla2xxx
	PHYSDEVBUS=pci
	PHYSDEVDRIVER=qla2xxx
	PCI_CLASS=C0400
	PCI_ID=1077:2532
	PCI_SUBSYS_ID=1077:015C
	PCI_SLOT_NAME=0000:1e:00.0
	MODALIAS=pci:v00001077d00002532sv00001077sd0000015Cbc0Csc04i00
	SEQNUM=3574

Thanks, AV
