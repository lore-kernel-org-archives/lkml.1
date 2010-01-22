Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073Ab0AVN6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0AVN6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242Ab0AVN6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:58:01 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46866 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0AVN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:58:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=S+W99BfBPL/aceFxAKirG+u0qw0we022glAoE8NH0O8vWgWp9KU8vWPLo8HvblOlxJ
         pro8Jam1lWI0EipRbjfkXiGJUXw2+wJl0F49C4Bvmgima/SwIUvtVpyXZhnmGc1J6YmK
         eDdEzUDNlRuJNJ5ceESRUbXKEsUstYtX0VZqY=
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 13:57:58 +0000
Message-ID: <87a5b0801001220557s3a62742n369741a5d0e3ef94@mail.gmail.com>
Subject: [PATCH] exec: Use a define for maximum process stack size in 
	STACK_GROWSUP case.
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-parisc@vger.kernel.org
Content-Type: multipart/mixed; boundary=00032555a3420b4f6e047dc13560
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00032555a3420b4f6e047dc13560
Content-Type: text/plain; charset=ISO-8859-1

Create a new define for the maximum allowed process stack size for
STACK_GROWSUP architectures. This allows the value to be overridden in
architecture specific code where necessary.

Signed-off-by: Will Newton <will.newton@gmail.com>
---

The only in-tree architecture this affects is parisc. I don't have a
parisc box here to test with, but I have tested this change on an
out-of-tree Linux port with STACK_GROWSUP set.

 fs/exec.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 632b02e..d37a626 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -573,10 +573,13 @@ int setup_arg_pages(struct linux_binprm *bprm,
 	unsigned long stack_base;

 #ifdef CONFIG_STACK_GROWSUP
-	/* Limit stack size to 1GB */
+	/* Limit stack size to 1GB by default. */
+#ifndef STACK_MAX_SIZE
+#define STACK_MAX_SIZE (1 << 30)
+#endif
 	stack_base = current->signal->rlim[RLIMIT_STACK].rlim_max;
-	if (stack_base > (1 << 30))
-		stack_base = 1 << 30;
+	if (stack_base > STACK_MAX_SIZE)
+		stack_base = STACK_MAX_SIZE;

 	/* Make sure we didn't let the argument array grow too large. */
 	if (vma->vm_end - vma->vm_start > stack_base)
-- 
1.5.5.2

--00032555a3420b4f6e047dc13560
Content-Type: application/octet-stream; 
	name="0001-exec-Use-a-define-for-maximum-process-stack-size-in.patch"
Content-Disposition: attachment; 
	filename="0001-exec-Use-a-define-for-maximum-process-stack-size-in.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4r1aq4f0

RnJvbSBlYjQ0YTQ0MTg0ZTQyZWQyYWZiMGQxZTg5OGI2Y2IzZjY4M2JjY2NmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBGcmksIDIyIEphbiAyMDEwIDEzOjUxOjMxICswMDAwClN1YmplY3Q6IFtQQVRDSF0gZXhl
YzogVXNlIGEgZGVmaW5lIGZvciBtYXhpbXVtIHByb2Nlc3Mgc3RhY2sgc2l6ZSBpbiBTVEFDS19H
Uk9XU1VQIGNhc2UuCgpDcmVhdGUgYSBuZXcgZGVmaW5lIGZvciB0aGUgbWF4aW11bSBhbGxvd2Vk
IHByb2Nlc3Mgc3RhY2sgc2l6ZSBmb3IKU1RBQ0tfR1JPV1NVUCBhcmNoaXRlY3R1cmVzLiBUaGlz
IGFsbG93cyB0aGUgdmFsdWUgdG8gYmUgb3ZlcnJpZGRlbiBpbgphcmNoaXRlY3R1cmUgc3BlY2lm
aWMgY29kZSB3aGVyZSBuZWNlc3NhcnkuCgpTaWduZWQtb2ZmLWJ5OiBXaWxsIE5ld3RvbiA8d2ls
bC5uZXd0b25AZ21haWwuY29tPgotLS0KIGZzL2V4ZWMuYyB8ICAgIDkgKysrKysrLS0tCiAxIGZp
bGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9mcy9leGVjLmMgYi9mcy9leGVjLmMKaW5kZXggNjMyYjAyZS4uZDM3YTYyNiAxMDA2NDQKLS0t
IGEvZnMvZXhlYy5jCisrKyBiL2ZzL2V4ZWMuYwpAQCAtNTczLDEwICs1NzMsMTMgQEAgaW50IHNl
dHVwX2FyZ19wYWdlcyhzdHJ1Y3QgbGludXhfYmlucHJtICpicHJtLAogCXVuc2lnbmVkIGxvbmcg
c3RhY2tfYmFzZTsKIAogI2lmZGVmIENPTkZJR19TVEFDS19HUk9XU1VQCi0JLyogTGltaXQgc3Rh
Y2sgc2l6ZSB0byAxR0IgKi8KKwkvKiBMaW1pdCBzdGFjayBzaXplIHRvIDFHQiBieSBkZWZhdWx0
LiAqLworI2lmbmRlZiBTVEFDS19NQVhfU0laRQorI2RlZmluZSBTVEFDS19NQVhfU0laRSAoMSA8
PCAzMCkKKyNlbmRpZgogCXN0YWNrX2Jhc2UgPSBjdXJyZW50LT5zaWduYWwtPnJsaW1bUkxJTUlU
X1NUQUNLXS5ybGltX21heDsKLQlpZiAoc3RhY2tfYmFzZSA+ICgxIDw8IDMwKSkKLQkJc3RhY2tf
YmFzZSA9IDEgPDwgMzA7CisJaWYgKHN0YWNrX2Jhc2UgPiBTVEFDS19NQVhfU0laRSkKKwkJc3Rh
Y2tfYmFzZSA9IFNUQUNLX01BWF9TSVpFOwogCiAJLyogTWFrZSBzdXJlIHdlIGRpZG4ndCBsZXQg
dGhlIGFyZ3VtZW50IGFycmF5IGdyb3cgdG9vIGxhcmdlLiAqLwogCWlmICh2bWEtPnZtX2VuZCAt
IHZtYS0+dm1fc3RhcnQgPiBzdGFja19iYXNlKQotLSAKMS41LjUuMgoK
--00032555a3420b4f6e047dc13560--
