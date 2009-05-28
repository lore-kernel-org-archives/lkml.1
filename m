Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZE1XFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZE1XFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZE1XCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:02:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32911 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbZE1XCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:02:25 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Thu, 28 May 2009 16:01:04 -0700
Message-Id: <1243551665-23596-23-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0031]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 23/24] driver core: Don't remove kobjects in device_shutdown.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

device_shutdown is defined to just shutdown the hardware and to not
clean up any kernel data structures.  Therefore don't put the kobjects
for /sys/dev and /sys/dev/block and /sys/dev/char.

This ensures we don't remove /sys/dev/block and /sys/dev/char while
we still have symlinks from there to the actual devices.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/base/core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8a1569c..49d3142 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1653,7 +1653,4 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
-	kobject_put(sysfs_dev_char_kobj);
-	kobject_put(sysfs_dev_block_kobj);
-	kobject_put(dev_kobj);
 }
-- 
1.6.3.1.54.g99dd.dirty

