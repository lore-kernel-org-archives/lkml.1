Return-Path: <linux-kernel-owner+w=401wt.eu-S1161192AbXBUNNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161192AbXBUNNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161216AbXBUNNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:13:10 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:60773 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161192AbXBUNNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:13:09 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] EXPORT_SYMBOL() time functions
Date: Wed, 21 Feb 2007 14:13:38 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <200702211412.23388.eike-kernel@sf-tec.de>
In-Reply-To: <200702211412.23388.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702211413.38840.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These functions were inlines before 8b9365d753d9870bb6451504c13570b81923228f.
Now EXPORT_SYMBOL() them to allow them to be used in modules again.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---

Sent once again, this time without PGP signature so importing into git is easier.

commit 0a543599f4a9ea02b587bda26e0e11ae94774f61
tree aa815eab413d2575925b0964a1fa01d41439b26b
parent 6b8afc66b9d6893d3fa292b75769b58539836ff3
author Rolf Eike Beer <eike-kernel@sf-tec.de> Wed, 21 Feb 2007 14:10:12 +0100
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Wed, 21 Feb 2007 14:10:12 +0100

 kernel/time.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index c6c80ea..0b351b2 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -635,6 +635,7 @@ timeval_to_jiffies(const struct timeval *value)
 		(((u64)usec * USEC_CONVERSION + USEC_ROUND) >>
 		 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
 }
+EXPORT_SYMBOL(timeval_to_jiffies);
 
 void jiffies_to_timeval(const unsigned long jiffies, struct timeval *value)
 {
@@ -649,6 +650,7 @@ void jiffies_to_timeval(const unsigned long jiffies, struct timeval *value)
 	tv_usec /= NSEC_PER_USEC;
 	value->tv_usec = tv_usec;
 }
+EXPORT_SYMBOL(jiffies_to_timeval);
 
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
@@ -723,6 +725,7 @@ u64 nsec_to_clock_t(u64 x)
 #endif
 	return x;
 }
+EXPORT_SYMBOL(nsec_to_clock_t);
 
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)
