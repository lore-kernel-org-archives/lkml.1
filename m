Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbYKTPB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbYKTPB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbYKTOrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:47:52 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:1963 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015AbYKTOru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:47:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=vjpfOfIrH1EV4AfKDGzOARCsgwB02A7waV+yF9qe6Y0hz2FxZJBLQ4M4e8yb07hi4G
         6Kgcf/kZopIq1hpyVXiBhd8oWvTctqFm1A077Ei0ED5Zohpr3WFNCPcuuLpb8EFQahTR
         pQDZ6p4Vi0hIxUeyTYMenf+s0P3u/2+91Tbh8=
Message-ID: <87a5b0800811200647t4de76a2ah683ac6083014d061@mail.gmail.com>
Date: Thu, 20 Nov 2008 14:47:50 +0000
From: "Will Newton" <will.newton@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] init/main.c: Use ktime accessor function in initcall_debug code.
Cc: "Tim Bird" <tim.bird@am.sony.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_71202_31435352.1227192470051"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_71202_31435352.1227192470051
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The initcall_debug code access the tv64 member of ktime. This won't work
correctly for large deltas on platforms that don't use the scalar ktime
implementation.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 7e117a2..0eff42a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -718,7 +718,7 @@ int do_one_initcall(initcall_t fn)
 	if (initcall_debug) {
 		it.rettime = ktime_get();
 		delta = ktime_sub(it.rettime, it.calltime);
-		it.duration = (unsigned long long) delta.tv64 >> 10;
+		it.duration = (unsigned long long) ktime_to_ns(delta) >> 10;
 		printk("initcall %pF returned %d after %Ld usecs\n", fn,
 			it.result, it.duration);
 		trace_boot(&it, fn);
-- 
1.5.5.2

------=_Part_71202_31435352.1227192470051
Content-Type: text/x-patch;
 name=0001-init-main.c-Use-ktime-accessor-function-in-initcall.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnri9bn90
Content-Disposition: attachment;
 filename=0001-init-main.c-Use-ktime-accessor-function-in-initcall.patch

RnJvbSBlOTY5N2VjOWRiNGQwNGI5YzYxNWQzNGI3NjU3MWFmYWJhYThkZmIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBUaHUsIDIwIE5vdiAyMDA4IDE0OjExOjU0ICswMDAwClN1YmplY3Q6IFtQQVRDSF0gaW5p
dC9tYWluLmM6IFVzZSBrdGltZSBhY2Nlc3NvciBmdW5jdGlvbiBpbiBpbml0Y2FsbF9kZWJ1ZyBj
b2RlLgoKVGhlIGluaXRjYWxsX2RlYnVnIGNvZGUgYWNjZXNzIHRoZSB0djY0IG1lbWJlciBvZiBr
dGltZS4gVGhpcyB3b24ndCB3b3JrCmNvcnJlY3RseSBvbiBwbGF0Zm9ybXMgdGhhdCBkb24ndCB1
c2UgdGhlIHNjYWxhciBrdGltZSBpbXBsZW1lbnRhdGlvbi4KClNpZ25lZC1vZmYtYnk6IFdpbGwg
TmV3dG9uIDx3aWxsLm5ld3RvbkBnbWFpbC5jb20+Ci0tLQogaW5pdC9tYWluLmMgfCAgICAyICst
CiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9pbml0L21haW4uYyBiL2luaXQvbWFpbi5jCmluZGV4IDdlMTE3YTIuLjBlZmY0MmEg
MTAwNjQ0Ci0tLSBhL2luaXQvbWFpbi5jCisrKyBiL2luaXQvbWFpbi5jCkBAIC03MTgsNyArNzE4
LDcgQEAgaW50IGRvX29uZV9pbml0Y2FsbChpbml0Y2FsbF90IGZuKQogCWlmIChpbml0Y2FsbF9k
ZWJ1ZykgewogCQlpdC5yZXR0aW1lID0ga3RpbWVfZ2V0KCk7CiAJCWRlbHRhID0ga3RpbWVfc3Vi
KGl0LnJldHRpbWUsIGl0LmNhbGx0aW1lKTsKLQkJaXQuZHVyYXRpb24gPSAodW5zaWduZWQgbG9u
ZyBsb25nKSBkZWx0YS50djY0ID4+IDEwOworCQlpdC5kdXJhdGlvbiA9ICh1bnNpZ25lZCBsb25n
IGxvbmcpIGt0aW1lX3RvX25zKGRlbHRhKSA+PiAxMDsKIAkJcHJpbnRrKCJpbml0Y2FsbCAlcEYg
cmV0dXJuZWQgJWQgYWZ0ZXIgJUxkIHVzZWNzXG4iLCBmbiwKIAkJCWl0LnJlc3VsdCwgaXQuZHVy
YXRpb24pOwogCQl0cmFjZV9ib290KCZpdCwgZm4pOwotLSAKMS41LjUuMgoK
------=_Part_71202_31435352.1227192470051--
