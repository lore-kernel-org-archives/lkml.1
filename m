Return-Path: <linux-kernel-owner+w=401wt.eu-S1763413AbYBUQul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763413AbYBUQul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934806AbYBUQtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:49:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934774AbYBUQtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:49:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values to
	do_div() [try #2]
To: torvalds@osdl.org, akpm@linux-foundation.org, zippel@linux-m68k.org,
       schwab@suse.de
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 21 Feb 2008 16:49:11 +0000
Message-ID: <20080221164911.16476.12046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

The kernel NTP code shouldn't hand 64-bit *signed* values to do_div().  Make it
instead hand 64-bit unsigned values.  This gets rid of a couple of warnings.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/time/ntp.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index c88b591..3bead00 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -342,13 +342,15 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
 		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
+			u64 utemp64;
 			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
 			if (time_offset < 0) {
-			    temp64 = -temp64;
-			    do_div(temp64, mtemp);
+			    utemp64 = -temp64;
+			    do_div(utemp64, mtemp);
 			    freq_adj -= temp64;
 			} else {
-			    do_div(temp64, mtemp);
+			    utemp64 = temp64;
+			    do_div(utemp64, mtemp);
 			    freq_adj += temp64;
 			}
 		    }

