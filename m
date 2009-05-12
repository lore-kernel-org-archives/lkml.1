Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbZELBNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbZELBNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 21:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbZELBNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 21:13:30 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47343 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbZELBN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 21:13:29 -0400
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP
 convergence
From: john stultz <johnstul@us.ibm.com>
To: mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org,
       Bernhard Schiffner <bernhard@schiffner-limbach.de>
In-Reply-To: <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org>
	 <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org>
Content-Type: text/plain
Date: Mon, 11 May 2009 18:13:13 -0700
Message-Id: <1242090794.7214.131.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 09:46 +0000, tip-bot for john stultz wrote:
> Commit-ID:  22cfbbfd9f67b67fe073010f51cb71d3632387d5
> Gitweb:     http://git.kernel.org/tip/22cfbbfd9f67b67fe073010f51cb71d3632387d5
> Author:     john stultz <johnstul@us.ibm.com>
> AuthorDate: Wed, 6 May 2009 11:43:57 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 6 May 2009 11:44:02 +0200
> 
> ntp: adjust SHIFT_PLL to improve NTP convergence
> 
> The conversion to the ntpv4 reference model
> f19923937321244e7dc334767eb4b67e0e3d5c74 ("ntp: convert to the NTP4
> reference model") in 2.6.19 added nanosecond resolution the adjtimex
> interface, but also changed the "stiffness" of the frequency adjustments,
> causing NTP convergence time to greatly increase.
> 
> SHIFT_PLL, which reduces the stiffness of the freq adjustments, was
> designed to be inversely linked to HZ, and the reference value of 4 was
> designed for Unix systems using HZ=100.  However Linux's clock steering
> code mostly independent of HZ.
> 
> So this patch reduces the SHIFT_PLL value from 4 to 2, which causes NTPd
> behavior to match kernels prior to 2.6.19, greatly reducing convergence
> times, and improving close synchronization through environmental thermal
> changes.
> 
> The patch also changes some l's to L's in nearby code to avoid misreading
> 50l as 501.
> 
> [ Impact: tweak NTP algorithm for faster convergence ]


Bernhard Schiffner noticed I had a few comment typos in this patch,
(note: to save embarrassment, when making typos, avoid copying and
pasting them) so this patch corrects them. 

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 0daf961..9910e3b 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -179,7 +179,7 @@ struct timex {
  * NTP convergence time. A higher value makes it stiffer, increasing
  * convergence time, but making the clock more stable.
  *
- * In David Mills' nanokenrel reference implmentation SHIFT_PLL is 4.
+ * In David Mills' nanokernel reference implementation SHIFT_PLL is 4.
  * However this seems to increase convergence time much too long.
  *
  * https://lists.ntp.org/pipermail/hackers/2008-January/003487.html
@@ -196,7 +196,7 @@ struct timex {
  *
  * SHIFT_FLL is used as a dampening factor to define how much we
  * adjust the frequency correction for a given offset in FLL mode.
- * In David Mills' nanokenrel reference implmentation SHIFT_PLL is 2.
+ * In David Mills' nanokernel reference implementation SHIFT_FLL is 2.
  *
  * MAXTC establishes the maximum time constant of the PLL.
  */


