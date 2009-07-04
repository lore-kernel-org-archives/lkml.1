Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZGDKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZGDKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZGDKZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:25:20 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:34228 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZGDKZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=IBIwtJX+DIJPV3R5bnEjcWMVO1UkX7RNAN3/SLdc4hdIITZrX7RAbMxmVqHLfUtnmz
         HruLseFdPpQicCWJ6ZN2fs7s5nsF4XPDIjCSVAs83+QzYzX5j9JM1UmSBOK3Gbrn+PHo
         UWsthuq38xb5uXdtYh2G7/av0FUEe2cI3EZGA=
MIME-Version: 1.0
In-Reply-To: <8126ef5c0907040322l4178a890odfdb46ad549f6ee1@mail.gmail.com>
References: <8126ef5c0907040322l4178a890odfdb46ad549f6ee1@mail.gmail.com>
Date: Sat, 4 Jul 2009 18:25:23 +0800
Message-ID: <8126ef5c0907040325h5a4744d2nf15d3a811213e4b1@mail.gmail.com>
Subject: PROBLEM: poll and select report different status
From: Zhao Shuai <upczhsh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00163645731ecbb038046ddeb0af
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163645731ecbb038046ddeb0af
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[1.] One line summary of the problem:
select and poll report different status

[2.] Full description of the problem/report:
A reader and a writer opens a fifo, then close the reader side and poll & select
on the writer side. Surprisingly, poll and select reports different
status. Poll says
the writer fd is unreadable & writable, but select says it's
readable(writer fd is
a WRITE ONLY descriptor!) & writable.

[3.] Keywords (i.e., modules, networking, kernel):
kernel

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
Linux version 2.6.24-24-generic (buildd@palmer) (gcc version 4.2.4
(Ubuntu 4.2.4-1ubuntu4))

[7.] A small shell script or example program which triggers the
problem (if possible)
see the attached file.


--
Regards,
Zhao

--00163645731ecbb038046ddeb0af
Content-Type: text/x-csrc; charset=US-ASCII; name="fifo_poll_select.c"
Content-Disposition: attachment; filename="fifo_poll_select.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwq6h2u20

LyoKICogYSByZWFkZXIgYW5kIGEgd3JpdGVyIG9wZW5zIGZpZm8sIHRoZW4gY2xvc2UgdGhlIHJl
YWRlciBzaWRlLAogKiBwb2xsIGFuZCBzZWxlY3Qgb24gd3JpdGVyIGZkIGNvbWVzIHRvIGRpZmZl
cmVudCByZXN1bHRzCiAqLwojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgoj
aW5jbHVkZSA8cG9sbC5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoj
aW5jbHVkZSA8c3lzL3NlbGVjdC5oPgojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxz
eXMvc3RhdC5oPgoKI2RlZmluZSBGSUZPX05BTUUgInRtcGZpZm8iCgppbnQgbWFpbihpbnQgYXJn
YywgY2hhciAqYXJndltdKQp7CglpbnQgcmVhZGVyX2ZkLCB3cml0ZXJfZmQ7CglzdHJ1Y3QgcG9s
bGZkIGZkc1sxXTsKCWZkX3NldCByZWFkZmRzLCB3cml0ZWZkcywgZXhjZXB0ZmRzOwoJCglpZiAo
bWtmaWZvKEZJRk9fTkFNRSwgMDc3NykgPCAwKSB7CgkJcGVycm9yKCJta2ZpZm8gZXJyb3IiKTsK
CQlyZXR1cm4gKC0xKTsKCX0KCglyZWFkZXJfZmQgPSBvcGVuKEZJRk9fTkFNRSwgT19SRE9OTFkg
fCBPX05PTkJMT0NLKTsKCWlmIChyZWFkZXJfZmQgPCAwKSB7CgkJcGVycm9yKCJyZWFkIG9wZW4g
ZXJyb3IiKTsKCQl1bmxpbmsoRklGT19OQU1FKTsKCQlyZXR1cm4gKC0xKTsKCX0KCgl3cml0ZXJf
ZmQgPSBvcGVuKEZJRk9fTkFNRSwgT19XUk9OTFkgfCBPX05PTkJMT0NLKTsKCWlmICh3cml0ZXJf
ZmQgPCAwKSB7CgkJcGVycm9yKCJ3cml0ZSBvcGVuIGVycm9yIik7CgkJdW5saW5rKEZJRk9fTkFN
RSk7CgkJcmV0dXJuICgtMSk7Cgl9CgkKCWZkc1swXS5mZCA9IHdyaXRlcl9mZDsKCWZkc1swXS5l
dmVudHMgPSBQT0xMSU4gfCBQT0xMT1VUIHwgUE9MTEVSUjsKCWZkc1swXS5yZXZlbnRzID0gMDsK
CglGRF9aRVJPKCZyZWFkZmRzKTsKCUZEX1pFUk8oJndyaXRlZmRzKTsKCUZEX1pFUk8oJmV4Y2Vw
dGZkcyk7CglGRF9TRVQod3JpdGVyX2ZkLCAmcmVhZGZkcyk7CglGRF9TRVQod3JpdGVyX2ZkLCAm
d3JpdGVmZHMpOwoJRkRfU0VUKHdyaXRlcl9mZCwgJmV4Y2VwdGZkcyk7CgoJLyogY2xvc2UgdGhl
IHJlYWRlciBzaWRlICovCgljbG9zZShyZWFkZXJfZmQpOwoKCS8qIHBvbGwgb24gdGhlIHdyaXRl
ciBzaWRlICovCglpZiAocG9sbChmZHMsIDEsIDApIDwgMCkgewoJCXBlcnJvcigicG9sbCBlcnJv
ciIpOwoJCXVubGluayhGSUZPX05BTUUpOwoJCXJldHVybiAoLTEpOwoJfQoJcHJpbnRmKCJwb2xs
IHJlc3VsdHM6ICIpOwoJaWYgKGZkc1swXS5yZXZlbnRzICYgUE9MTElOKQoJCXByaW50ZigiIHJl
YWRhYmxlICIpOwoJaWYgKGZkc1swXS5yZXZlbnRzICYgUE9MTE9VVCkKCQlwcmludGYoIiB3cml0
YWJsZSAiKTsKCWlmIChmZHNbMF0ucmV2ZW50cyAmIFBPTExIVVApCgkJcHJpbnRmKCIgaGFuZyB1
cCIpOwoJaWYgKGZkc1swXS5yZXZlbnRzICYgUE9MTEVSUikKCQlwcmludGYoIiBlcnJvciAiKTsK
CWlmIChmZHNbMF0ucmV2ZW50cyAmIFBPTExOVkFMKQoJCXByaW50ZigiIGludmFsaWQgZmQgIik7
CglwcmludGYoIlxuIik7CgoJLyogc2VsZWN0IG9uIHRoZSB3cml0ZXIgc2lkZSAqLwoJaWYgKHNl
bGVjdCh3cml0ZXJfZmQrMSwgJnJlYWRmZHMsICZ3cml0ZWZkcywgJmV4Y2VwdGZkcywgTlVMTCkg
PCAwKSB7CgkJcGVycm9yKCJzZWxlY3QgZXJyb3IiKTsKCQl1bmxpbmsoRklGT19OQU1FKTsKCQly
ZXR1cm4gKC0xKTsKCX0KCXByaW50Zigic2VsZWN0IHJlc3VsdDogIik7CglpZiAoRkRfSVNTRVQo
d3JpdGVyX2ZkLCAmcmVhZGZkcykpCgkJcHJpbnRmKCIgcmVhZGFibGUgIik7CglpZiAoRkRfSVNT
RVQod3JpdGVyX2ZkLCAmd3JpdGVmZHMpKQoJCXByaW50ZigiIHdyaXRhYmxlICIpOwoJaWYgKEZE
X0lTU0VUKHdyaXRlcl9mZCwgJmV4Y2VwdGZkcykpCgkJcHJpbnRmKCIgZXhjZXB0aW9uYWwgIik7
CglwcmludGYoIlxuIik7CgoJdW5saW5rKEZJRk9fTkFNRSk7CglyZXR1cm4gKDApOwp9Cg==
--00163645731ecbb038046ddeb0af--
