Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbYJaNJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbYJaNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJaNJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:09:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:39403 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYJaNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:references;
        b=n/HiuffCVX/VUN+4mB3EAvFn1h7fkYKll5UNW2w6hNhPyeFxUdFXArcimnbLx6I5s0
         R3dkKsF+1GFuERP4bLVw5EnBQvVTjb9BD61AtiBMcURo37t1HeGAgjanoQjbIC2mBuSc
         7yKR/FPVmjVtUUbLf/jrPz9IjGQVvF5eoblSg=
Message-ID: <eed7af970810310609o632034dia6140f7bec6fee66@mail.gmail.com>
Date: Fri, 31 Oct 2008 16:09:48 +0300
From: "Max Dmitrichenko" <dmitrmax@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix PCI resource mmaping on sparc64
In-Reply-To: <eed7af970810310513h6c466ce5h7ada2013ab4053b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_28024_12277622.1225458588679"
References: <eed7af970810310513h6c466ce5h7ada2013ab4053b1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_28024_12277622.1225458588679
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

There is a problem discovered in recent versions of ATI Mach64 driver
in X.org on sparc64 architecture. In short, the driver fails to mmap
MMIO aperture (PCI resource #2).

I've found that kernel's __pci_mmap_make_offset() returns EINVAL. It
checks whether user attempts to mmap more than the resource length,
which is 0x1000 bytes in our case. But PAGE_SIZE on SPARC64 is 0x2000
and this is what actually is being mmaped. So __pci_mmap_make_offset()
failed for this PCI resource.

Signed-off-by: Max Dmitrichenko <dmitrmax@gmail.com>

Code seems to be rather old. At least it was the same in 2.6.24. I
have no explanation why this bug exposed only now. May be before X.org
used to use some other method to mmap PCI resource into userspace (now
it uses libpciaccess).

The patch is against 2.6.26. Greg, please consider to include it into
the stable trees.

Please put me in CC if you're replying this message.

--
Max

------=_Part_28024_12277622.1225458588679
Content-Type: text/x-diff; name=sparc64-pci-mmap-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=sparc64-pci-mmap-fix.patch

ZGlmZiAtdXByTiBsaW51eC1zb3VyY2UtMi42LjI2L2FyY2gvc3BhcmM2NC9rZXJuZWwvcGNpLmMg
bGludXgtc291cmNlLTIuNi4yNi5wY2ktZml4ZWQvYXJjaC9zcGFyYzY0L2tlcm5lbC9wY2kuYwot
LS0gbGludXgtc291cmNlLTIuNi4yNi9hcmNoL3NwYXJjNjQva2VybmVsL3BjaS5jCTIwMDgtMDct
MTQgMDE6NTE6MjkuMDAwMDAwMDAwICswNDAwCisrKyBsaW51eC1zb3VyY2UtMi42LjI2LnBjaS1m
aXhlZC9hcmNoL3NwYXJjNjQva2VybmVsL3BjaS5jCTIwMDgtMTAtMzEgMDE6MjM6NTQuMDAwMDAw
MDAwICswMzAwCkBAIC0xMDE3LDYgKzEwMTcsNyBAQCBzdGF0aWMgaW50IF9fcGNpX21tYXBfbWFr
ZV9vZmZzZXQoc3RydWN0CiAKIAlmb3IgKGkgPSAwOyBpIDw9IFBDSV9ST01fUkVTT1VSQ0U7IGkr
KykgewogCQlzdHJ1Y3QgcmVzb3VyY2UgKnJwID0gJnBkZXYtPnJlc291cmNlW2ldOworCQlyZXNv
dXJjZV9zaXplX3QgYWxpZ25lZF9lbmQ7CiAKIAkJLyogQWN0aXZlPyAqLwogCQlpZiAoIXJwLT5m
bGFncykKQEAgLTEwMzQsOCArMTAzNSwxNSBAQCBzdGF0aWMgaW50IF9fcGNpX21tYXBfbWFrZV9v
ZmZzZXQoc3RydWN0CiAJCQkJY29udGludWU7CiAJCX0KIAorCQkvKiBBbGlnbiB0aGUgcmVzb3Vy
Y2UgZW5kIHRvIHRoZSBuZXh0IHBhZ2UgYWRkcmVzcy4KKyAgICAgICAgICAgICAgICAgKiBQQUdF
X1NJWkUgaW50ZW50aW9uYWxseSBhZGRlZCBpbnN0ZWFkIG9mIChQQUdFX1NJWkUgLSAxKSwKKyAg
ICAgICAgICAgICAgICAgKiBiZWNhdXNlIGFjdHVhbGx5IHdlIG5lZWQgdGhlIGFkZHJlc3Mgb2Yg
dGhlIG5leHQgYnl0ZQorICAgICAgICAgICAgICAgICAqIGFmdGVyIHJwLT5lbmQuCisgICAgICAg
ICAgICAgICAgICovCisJCWFsaWduZWRfZW5kID0gKHJwLT5lbmQgKyBQQUdFX1NJWkUpICYgUEFH
RV9NQVNLOworCiAJCWlmICgocnAtPnN0YXJ0IDw9IHVzZXJfcGFkZHIpICYmCi0JCSAgICAodXNl
cl9wYWRkciArIHVzZXJfc2l6ZSkgPD0gKHJwLT5lbmQgKyAxVUwpKQorCQkgICAgKHVzZXJfcGFk
ZHIgKyB1c2VyX3NpemUpIDw9IGFsaWduZWRfZW5kKQogCQkJYnJlYWs7CiAJfQogCg==
------=_Part_28024_12277622.1225458588679--
