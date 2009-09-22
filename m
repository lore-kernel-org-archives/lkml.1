Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZIVHRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZIVHRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZIVHRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:17:06 -0400
Received: from mail-pz0-f173.google.com ([209.85.222.173]:44761 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZIVHRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MSUpSbaiflv8vxHTtG5q6U4RVFPCtL8qmHdM79XMJUb3/bZjFGOFCOtaslLoRRBfT3
         yJw1AoMYRwyncP9sBmAwR3So8U1dEuPYiadiQTrqnMLo8mkYQ61B3dkLyvctFLcgazKh
         0iGXAVNTwVQ2EXDqtDp5//CpehJBWXFEmWuNw=
MIME-Version: 1.0
Date: Tue, 22 Sep 2009 15:17:08 +0800
Message-ID: <3877989d0909220017l61394c3cy769e95656db70d22@mail.gmail.com>
Subject: [RFC PATCH] delete unnecessary BUG_ON !policy->cur
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

When testing upstream Git tree, there is a BUG_ON hit on a IA64 system
with RHEL 5 user space installed.
Please review the patch below, If make sense, please apply.

Ps. The patch is enclosed in attachment. The inlined one
is c&p of it for reading.


Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

 cpufreq_userspace.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_userspace.c
b/drivers/cpufreq/cpufreq_userspace.c
index 66d2d1d..63bd232 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -119,7 +119,6 @@ static int cpufreq_governor_userspace(st
 	case CPUFREQ_GOV_START:
 		if (!cpu_online(cpu))
 			return -EINVAL;
-		BUG_ON(!policy->cur);
 		mutex_lock(&userspace_mutex);

 		if (cpus_using_userspace_governor == 0) {
