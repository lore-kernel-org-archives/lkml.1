Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZAFH0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZAFH0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbZAFHZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:25:59 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:34460 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZAFHZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:25:58 -0500
Date: Tue, 6 Jan 2009 12:55:49 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: linux-ppc <linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.28-git4 - powerpc - drivers build fails with
	!CONFIG_VIOPATH
Message-ID: <20090106072549.GA5066@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <5414eaef99b7392a95f6e3488b81dbf7@bga.com> <20090104182441.GA5086@linux.vnet.ibm.com> <98d6aef17cba9d835d7866745f811dc7@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <98d6aef17cba9d835d7866745f811dc7@bga.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Milton Miller <miltonm@bga.com> [2009-01-05 07:33:32]:

> On Jan 4, 2009, at 12:24 PM, Kamalesh Babulal wrote:
>
>> Hi Milton,
>>
>> 	Thanks for the review comments, I am resending the patch with the
>> changes you have recommended.
>>
>> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>
> Better, but you didn't include the change log, nor did you respond to 
> Stephen's reply suggesting that all users be converted to select viopath 
> (versus the proposed 2 select and 5 get it via depends and default y).
>
> milton
>

Hi Milton/Stephen,

	Sorry for resending the patch before taking care of the response. Resending 
the patch with changes made to other three drivers also.

Impact: Fix the VIOPATH dependency in the iSeries dependent drivers.

iSeries depend drivers build fails, when CONFIG_VIOPATH is disabled.
Removing the dependency of VIOPATH by selecting it, when the drivers
dependent on iSeries code.


Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/iseries/Kconfig |    5 ++++-
 drivers/char/Kconfig                   |    1 +
 drivers/scsi/Kconfig                   |    1 +
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/iseries/Kconfig b/arch/powerpc/platforms/iseries/Kconfig
index ed3753d..5cb2320 100644
--- a/arch/powerpc/platforms/iseries/Kconfig
+++ b/arch/powerpc/platforms/iseries/Kconfig
@@ -10,18 +10,21 @@ menu "iSeries device drivers"
 config VIODASD
 	tristate "iSeries Virtual I/O disk support"
 	depends on BLOCK
+	select VIOPATH
 	help
 	  If you are running on an iSeries system and you want to use
 	  virtual disks created and managed by OS/400, say Y.
 
 config VIOCD
 	tristate "iSeries Virtual I/O CD support"
+	select VIOPATH
 	help
 	  If you are running Linux on an IBM iSeries system and you want to
 	  read a CD drive owned by OS/400, say Y here.
 
 config VIOTAPE
 	tristate "iSeries Virtual Tape Support"
+	select VIOPATH
 	help
 	  If you are running Linux on an iSeries system and you want Linux
 	  to read and/or write a tape drive owned by OS/400, say Y here.
@@ -30,5 +33,5 @@ endmenu
 
 config VIOPATH
 	bool
-	depends on VIODASD || VIOCD || VIOTAPE || ISERIES_VETH
+	depends on PPC_ISERIES
 	default y
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
