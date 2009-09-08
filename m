Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbZIHC0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbZIHC0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 22:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZIHC0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 22:26:05 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:61980 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZIHC0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 22:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Dm8T5AXPXfwZ7Ww31sg+8dlkl91Nhk30KUgCFIg5wdXM1dOZXf5YSbCd87jjdAjXJU
         bAjZ3aWEE8Nj0CFCSGR+cZZoW3x7YSP2LB5TpMRf5JNAXLkaDo3CPWuMRDk+L3bw5o2a
         akr3/N52j0cBsKvS9NUL2p8mZJL1UvjiMYykQ=
MIME-Version: 1.0
Date: Tue, 8 Sep 2009 10:26:06 +0800
Message-ID: <3877989d0909071926q77aac67cj532137513710025d@mail.gmail.com>
Subject: [RFC PATCH] C2 could be mapped to C3 so need a flush cache
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Content-Type: multipart/mixed; boundary=00504502cb1c50b77c047307b0cb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502cb1c50b77c047307b0cb
Content-Type: text/plain; charset=UTF-8

Hi there,

I came across acpi_idle_enter_simple, noticed it looks like a bug if
we don't flush cache for C2.
Because some platforms just map C2 to C3.

Please review. If make sense, please apply.

Ps. The patch is enclosed in attachment. The inlined one
is c&p of it for reading.


Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

 processor_idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0efa59e..4fa9582 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -893,7 +893,7 @@ static int acpi_idle_enter_simple(struct
cpuidle_device *dev,
 	 */
 	lapic_timer_state_broadcast(pr, cx, 1);

-	if (cx->type == ACPI_STATE_C3)
+	if (cx->type == ACPI_STATE_C3 || cx->type == ACPI_STATE_C2)
 		ACPI_FLUSH_CPU_CACHE();

 	kt1 = ktime_get_real();

--00504502cb1c50b77c047307b0cb
Content-Type: application/octet-stream; name="8.patch"
Content-Disposition: attachment; filename="8.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzc10f5s0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfaWRsZS5jIGIvZHJpdmVycy9hY3Bp
L3Byb2Nlc3Nvcl9pZGxlLmMKaW5kZXggMGVmYTU5ZS4uNGZhOTU4MiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9hY3BpL3Byb2Nlc3Nvcl9pZGxlLmMKKysrIGIvZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl9p
ZGxlLmMKQEAgLTg5Myw3ICs4OTMsNyBAQCBzdGF0aWMgaW50IGFjcGlfaWRsZV9lbnRlcl9zaW1w
bGUoc3RydWN0IGNwdWlkbGVfZGV2aWNlICpkZXYsCiAJICovCiAJbGFwaWNfdGltZXJfc3RhdGVf
YnJvYWRjYXN0KHByLCBjeCwgMSk7CiAKLQlpZiAoY3gtPnR5cGUgPT0gQUNQSV9TVEFURV9DMykK
KwlpZiAoY3gtPnR5cGUgPT0gQUNQSV9TVEFURV9DMyB8fCBjeC0+dHlwZSA9PSBBQ1BJX1NUQVRF
X0MyKQogCQlBQ1BJX0ZMVVNIX0NQVV9DQUNIRSgpOwogCiAJa3QxID0ga3RpbWVfZ2V0X3JlYWwo
KTsK
--00504502cb1c50b77c047307b0cb--
