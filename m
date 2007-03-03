Return-Path: <linux-kernel-owner+w=401wt.eu-S1030412AbXCCVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412AbXCCVlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030449AbXCCVlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:41:39 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:49433 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030412AbXCCVli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:41:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=slNJEd+fyvRiprZVx1scS3PJgNwUnGADH/KJLXX5/6iMSNu7BptNIHeHmi1V8UZCcid1Tjsg0qxrbyRbwmZ4/ddRuQXA8Ahn0L3KBnOpP46G02C6j52hLcKjny8XvOsKKQVy5nrI8bYef+Q5RzNuizBzyDW0JAF3VfLWNSMDkbo=
Message-ID: <3d8471ca0703031341l1768fe7rccf40712e452ea09@mail.gmail.com>
Date: Sat, 3 Mar 2007 22:41:36 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [1/3] Bugfix: Don't use the TSC in sched_clock if unstable
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f9690982b8c2f9a2c65acdc113e758ec356676a3
caused a regression by letting sched_clock use the TSC even when cpufreq
disabled it. This caused scheduling weirdnesses.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

diff -r 529142505a77 arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c	Fri Mar 02 17:58:52 2007 -0800
+++ b/arch/i386/kernel/tsc.c	Sat Mar 03 21:39:08 2007 +0100
@@ -108,7 +108,7 @@ unsigned long long sched_clock(void)
 	/*
 	 * Fall back to jiffies if there's no TSC available:
 	 */
-	if (unlikely(tsc_disable))
+	if (tsc_unstable || unlikely(tsc_disable))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);



-- 
Guillaume
