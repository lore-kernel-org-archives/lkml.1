Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbYHZRwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbYHZRwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYHZRwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:52:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:13587 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYHZRwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=HI9jsovBpoOjlUjRLWOQz4UW+MdfiYBdMe3DqGuca1Uso5zwQo8fr0BQJPWrQgeUlZ
         Xc5AwDR1uT2ZWXUxjm3Q9DybYScbPCG7YbnmGrIK3lBKpSxe4I+urPn7lo/f9Xdr/rjS
         tlpJ/850PTylkAZmeUefV266xaZDXyFDzko9s=
Message-ID: <48B442C3.2000309@gmail.com>
Date: Tue, 26 Aug 2008 20:52:03 +0300
From: "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg Ungerer <gerg@uclinux.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] uclinux: fix gzip header parsing in binfmt_flat.c
Content-Type: multipart/mixed;
 boundary="------------060902080803010501010806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060902080803010501010806
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There are off-by-one errors in decompress_exec() when calculating the length of
optional "original file name" and "comment" fields: the "ret" index is not
incremented when terminating '\0' character is reached. The check of the buffer
overflow (after an "extra-field" length was taken into account) is also fixed.

Signed-off-by: Volodymyr G Lukiianyk <volodymyrgl@gmail.com>
---

I've encountered this off-by-one error when tried to reuse gzip-header-parsing
part of the decompress_exec() function. There was an "original file name" field
in the payload (with miscalculated length) and zlib_inflate() returned
Z_DATA_ERROR. But after the fix similar to this one all worked fine.

WARNING: the proposed patch wasn't properly tested.

--------------060902080803010501010806
Content-Type: text/x-patch;
 name="binfmt_flat_decompress_fix.diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="binfmt_flat_decompress_fix.diff"

G1sxbWRpZmYgLS1naXQgYS9mcy9iaW5mbXRfZmxhdC5jIGIvZnMvYmluZm10X2ZsYXQuYxtb
bQobWzFtaW5kZXggZGZjMDE5Ny4uY2NiNzgxYSAxMDA2NDQbW20KG1sxbS0tLSBhL2ZzL2Jp
bmZtdF9mbGF0LmMbW20KG1sxbSsrKyBiL2ZzL2JpbmZtdF9mbGF0LmMbW20KG1szNm1AQCAt
MjI5LDEzICsyMjksMTMgQEAgc3RhdGljIGludCBkZWNvbXByZXNzX2V4ZWMoChtbbSAJcmV0
ID0gMTA7ChtbbSAJaWYgKGJ1ZlszXSAmIEVYVFJBX0ZJRUxEKSB7ChtbbSAJCXJldCArPSAy
ICsgYnVmWzEwXSArIChidWZbMTFdIDw8IDgpOwobW20bWzMxbS0JCWlmICh1bmxpa2VseShM
QlVGU0laRSA9PSByZXQpKSB7ChtbbRtbMzJtKxtbbQkJG1szMm1pZiAodW5saWtlbHkoTEJV
RlNJWkUgPD0gcmV0KSkgextbbQogCQkJREJHX0ZMVCgiYmluZm10X2ZsYXQ6IGJ1ZmZlciBv
dmVyZmxvdyAoRVhUUkEpP1xuIik7ChtbbSAJCQlnb3RvIG91dF9mcmVlX2J1ZjsKG1ttIAkJ
fQobW20gCX0KG1ttIAlpZiAoYnVmWzNdICYgT1JJR19OQU1FKSB7ChtbbRtbMzFtLQkJZm9y
ICg7IHJldCA8IExCVUZTSVpFICYmIChidWZbcmV0XSAhPSAwKTsgcmV0KyspChtbbRtbMzJt
KxtbbQkJG1szMm13aGlsZSAocmV0IDwgTEJVRlNJWkUgJiYgYnVmW3JldCsrXSAhPSAwKRtb
bQogCQkJOwobW20gCQlpZiAodW5saWtlbHkoTEJVRlNJWkUgPT0gcmV0KSkgewobW20gCQkJ
REJHX0ZMVCgiYmluZm10X2ZsYXQ6IGJ1ZmZlciBvdmVyZmxvdyAoT1JJR19OQU1FKT9cbiIp
OwobW20bWzM2bUBAIC0yNDMsNyArMjQzLDcgQEAgc3RhdGljIGludCBkZWNvbXByZXNzX2V4
ZWMoChtbbSAJCX0KG1ttIAl9ChtbbSAJaWYgKGJ1ZlszXSAmIENPTU1FTlQpIHsKG1ttG1sz
MW0tCQlmb3IgKDsgIHJldCA8IExCVUZTSVpFICYmIChidWZbcmV0XSAhPSAwKTsgcmV0Kysp
ChtbbRtbMzJtKxtbbQkJG1szMm13aGlsZSAocmV0IDwgTEJVRlNJWkUgJiYgYnVmW3JldCsr
XSAhPSAwKRtbbQogCQkJOwobW20gCQlpZiAodW5saWtlbHkoTEJVRlNJWkUgPT0gcmV0KSkg
ewobW20gCQkJREJHX0ZMVCgiYmluZm10X2ZsYXQ6IGJ1ZmZlciBvdmVyZmxvdyAoQ09NTUVO
VCk/XG4iKTsKG1tt
--------------060902080803010501010806--
