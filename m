Return-Path: <linux-kernel-owner+w=401wt.eu-S1751426AbZADJEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbZADJEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 04:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZADJD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 04:03:59 -0500
Received: from mercury.realtime.net ([205.238.132.86]:34489 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZADJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 04:03:57 -0500
X-Greylist: delayed 989 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2009 04:03:57 EST
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <5414eaef99b7392a95f6e3488b81dbf7@bga.com>
Content-Transfer-Encoding: 7bit
Cc: linux-ppc <linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] 2.6.28-git4 - powerpc - drivers build fails with !CONFIG_VIOPATH
Date: Sun, 4 Jan 2009 02:54:15 -0600
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 205.232.218.105
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In-Reply-To: <20090103191359.GA9304@linux.vnet.ibm.com>

Kamalesh Babulal wrote:
>  config SCSI_IBMVSCSI
>         tristate "IBM Virtual SCSI support"
> -       depends on PPC_PSERIES || PPC_ISERIES
> +       depends on (PPC_PSERIES || PPC_ISERIES) && VIOPATH
>         select SCSI_SRP_ATTRS
>         help
>           This is the IBM POWER Virtual SCSI Client

As VIOPATH is iSeries code and is only used by the iSeries code, the 
requirment should be

depends on PPC_PSERIES || (PPC_ISERIES && VIOPATH)

except VIOPATH isn't selectable:

arch/powerpc/platforms/iseries/Kconfig:

  config VIOPATH
         bool
         depends on VIODASD || VIOCD || VIOTAPE || ISERIES_VETH
         default y

so instead we should be adding

select VIOPATH if PPC_ISERIES

to SCSI_IBMVSCSI and just

select VIOPATH

to HVC_ISERIES as it depends on PPC_ISERIES

otherwise you have to enable one driver to get these other drivers.

milton

