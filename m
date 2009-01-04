Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbZADSbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbZADSbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZADSbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:31:13 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:37641 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZADSbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:31:11 -0500
Date: Sun, 4 Jan 2009 23:54:41 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: linux-ppc <linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.28-git4 - powerpc - drivers build fails with
	!CONFIG_VIOPATH
Message-ID: <20090104182441.GA5086@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <5414eaef99b7392a95f6e3488b81dbf7@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5414eaef99b7392a95f6e3488b81dbf7@bga.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Milton Miller <miltonm@bga.com> [2009-01-04 02:54:15]:

> In-Reply-To: <20090103191359.GA9304@linux.vnet.ibm.com>
>
> Kamalesh Babulal wrote:
>>  config SCSI_IBMVSCSI
>>         tristate "IBM Virtual SCSI support"
>> -       depends on PPC_PSERIES || PPC_ISERIES
>> +       depends on (PPC_PSERIES || PPC_ISERIES) && VIOPATH
>>         select SCSI_SRP_ATTRS
>>         help
>>           This is the IBM POWER Virtual SCSI Client
>
> As VIOPATH is iSeries code and is only used by the iSeries code, the 
> requirment should be
>
> depends on PPC_PSERIES || (PPC_ISERIES && VIOPATH)
>
> except VIOPATH isn't selectable:
>
> arch/powerpc/platforms/iseries/Kconfig:
>
>  config VIOPATH
>         bool
>         depends on VIODASD || VIOCD || VIOTAPE || ISERIES_VETH
>         default y
>
> so instead we should be adding
>
> select VIOPATH if PPC_ISERIES
>
> to SCSI_IBMVSCSI and just
>
> select VIOPATH
>
> to HVC_ISERIES as it depends on PPC_ISERIES
>
> otherwise you have to enable one driver to get these other drivers.
>
> milton
>

Hi Milton,

	Thanks for the review comments, I am resending the patch with the 
changes you have recommended.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
 drivers/char/Kconfig |    1 +
 drivers/scsi/Kconfig |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 1697043..b8da09a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -616,6 +616,7 @@ config HVC_ISERIES
 	default y
 	select HVC_DRIVER
 	select HVC_IRQ
+	select VIOPATH
 	help
 	  iSeries machines support a hypervisor virtual console.
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index b732297..256c7be 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -884,6 +884,7 @@ config SCSI_IBMVSCSI
 	tristate "IBM Virtual SCSI support"
 	depends on PPC_PSERIES || PPC_ISERIES
 	select SCSI_SRP_ATTRS
+	select VIOPATH if PPC_ISERIES
 	help
 	  This is the IBM POWER Virtual SCSI Client
 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
