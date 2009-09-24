Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZIXHGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZIXHGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 03:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZIXHGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 03:06:50 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:34895 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZIXHGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=jCWJzxLo4IgjVRr/Ib1235nh8Iw/UsCh7gizEeFTwU30tbeKTPVOB0V9b/3JLx8TEd
         mjgOVdH2H2zCQSpadm/0jZ6PuReM8cPN++HZELfDRsvQW2SmBI9clRNKQcqLtu5rJ9dn
         xVIEZUDdy4nPeSvAx0M5vxM0AOqwF5lR2jCzU=
MIME-Version: 1.0
Date: Thu, 24 Sep 2009 15:06:54 +0800
Message-ID: <3877989d0909240006r1db0607etb8d2857c1e165316@mail.gmail.com>
Subject: [RFC PATCH] delete unnecessary wbinvd while entering C3 for Intel CPU
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Content-Type: multipart/mixed; boundary=005045017f2cf5c58704744d7912
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--005045017f2cf5c58704744d7912
Content-Type: text/plain; charset=UTF-8

Hi there,

I came across acpi_idle_enter_simple, noticed wbinvd
is an unnecessary overhead for all Intel MP CPUs that
support C3 share cache. And caches should not be
flushed by software while entering C3 type state.

Please review. If make sense, please apply.

Ps. The patch is enclosed in attachment. The inlined one
is c&p of it for reading.


Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

 processor_idle.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 66393d5..4a2355b 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -894,10 +894,6 @@ static int acpi_idle_enter_simple(struct
cpuidle_device *dev,
 	 * access HPET !
 	 */
 	lapic_timer_state_broadcast(pr, cx, 1);
-
-	if (cx->type == ACPI_STATE_C3)
-		ACPI_FLUSH_CPU_CACHE();
-
 	kt1 = ktime_get_real();
 	/* Tell the scheduler that we are going deep-idle: */
 	sched_clock_idle_sleep_event();

--005045017f2cf5c58704744d7912
Content-Type: application/octet-stream; name="11.patch"
Content-Disposition: attachment; filename="11.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzz64ujd0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfaWRsZS5jIGIvZHJpdmVycy9hY3Bp
L3Byb2Nlc3Nvcl9pZGxlLmMKaW5kZXggNjYzOTNkNS4uNGEyMzU1YiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9hY3BpL3Byb2Nlc3Nvcl9pZGxlLmMKKysrIGIvZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl9p
ZGxlLmMKQEAgLTg5NCwxMCArODk0LDYgQEAgc3RhdGljIGludCBhY3BpX2lkbGVfZW50ZXJfc2lt
cGxlKHN0cnVjdCBjcHVpZGxlX2RldmljZSAqZGV2LAogCSAqIGFjY2VzcyBIUEVUICEKIAkgKi8K
IAlsYXBpY190aW1lcl9zdGF0ZV9icm9hZGNhc3QocHIsIGN4LCAxKTsKLQotCWlmIChjeC0+dHlw
ZSA9PSBBQ1BJX1NUQVRFX0MzKQotCQlBQ1BJX0ZMVVNIX0NQVV9DQUNIRSgpOwotCiAJa3QxID0g
a3RpbWVfZ2V0X3JlYWwoKTsKIAkvKiBUZWxsIHRoZSBzY2hlZHVsZXIgdGhhdCB3ZSBhcmUgZ29p
bmcgZGVlcC1pZGxlOiAqLwogCXNjaGVkX2Nsb2NrX2lkbGVfc2xlZXBfZXZlbnQoKTsK
--005045017f2cf5c58704744d7912--
