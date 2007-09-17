Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbXIQUhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbXIQUhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXIQUg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:36:57 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:13598 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbXIQUg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:36:57 -0400
Message-ID: <46EEE483.4020209@linux-kernel.at>
Date: Mon, 17 Sep 2007 22:33:07 +0200
From: Oliver Falk <oliver@linux-kernel.at>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, axp-list@redhat.com,
       Jay Estabrook <jay.estabrook@hp.com>, ac-admin@lists.anotherbloody.com
Content-Type: multipart/mixed;
 boundary="------------070607000906090002000009"
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60)
X-MailScanner-From: oliver@linux-kernel.at
Subject: 2.6.23 alpha unistd.h changes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070607000906090002000009
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi!

At Alphacore we used to patch the kernel headers for a while now; We
added syscalls __NR_openat (447) until __NR_tee (466).

However, since 2.6.23 these syscall where added upstream, but with
different syscall numbers; What happens is the following:

* glibc 2.6.90 compiled with 2.6.23 headers installed
* kernel 2.6.21 (our patched headers in place, different syscall
'ordering'/numbers) installed

[root@tyskie ~]# uname -r; touch x; rm -f x
2.6.23-0.145.rc4.fc8
rm: cannot remove `x': File exists

:-( I don't want to live without rm :-P and chmod doesn't work as well...

If I start 2.6.15, where these syscalls where not in place, it works
just fine. If I install old glibc 2.6 (compiled against 2.6.21 headers)
and kernel 2.6.21 also everything is fine.

Final test was now:
* Boot kernel 2.6.23 and glibc 2.6.90 (compiled against 2.6.23 headers),
also everything seems to work.

As these additions are quite new to upstream kernel, but at Alphacore we
have patched it since a while now (I don't know about other Alpha ports;
Debian folks may speak up now!), I would suggest to use the same
'ordering' of the syscalls upstream and add the new syscalls that we had
not in place, but are now upstream to the end of our 'old' list.

I have attached our patch that we used for 2.6.21.


Please let me know if that's fine everyone and keep me posted directly
and only via m/l, as I might miss the mail then...

Best,
 Oliver

--------------070607000906090002000009
Content-Type: application/octet-stream;
 name="linux-2.6.21-alpha_missing_syscalls.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="linux-2.6.21-alpha_missing_syscalls.patch"

LS0tIGxpbnV4LTIuNi4yMS9pbmNsdWRlL2FzbS1hbHBoYS91bmlzdGQuaC5taXNzaW5nX2Rl
ZmluZXMJMjAwNy0wNS0xNiAxMDo1MzowMi4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4LTIu
Ni4yMS9pbmNsdWRlL2FzbS1hbHBoYS91bmlzdGQuaAkyMDA3LTA1LTE2IDEwOjU0OjQ0LjAw
MDAwMDAwMCArMDIwMApAQCAtMzg4LDkgKzM4OCwzMCBAQAogI2RlZmluZSBfX05SX2lub3Rp
ZnlfYWRkX3dhdGNoCQk0NDUKICNkZWZpbmUgX19OUl9pbm90aWZ5X3JtX3dhdGNoCQk0NDYK
IAorI2RlZmluZSBfX05SX29wZW5hdCAgICAgICAgICAgICA0NDcKKyNkZWZpbmUgX19OUl9t
a2RpcmF0ICAgICAgICAgICAgNDQ4CisjZGVmaW5lIF9fTlJfbWtub2RhdCAgICAgICAgICAg
IDQ0OQorI2RlZmluZSBfX05SX2ZjaG93bmF0ICAgICAgICAgICA0NTAKKyNkZWZpbmUgX19O
Ul9mdXRpbWVzYXQgICAgICAgICAgNDUxCisjZGVmaW5lIF9fTlJfdW5saW5rYXQgICAgICAg
ICAgIDQ1MgorI2RlZmluZSBfX05SX3JlbmFtZWF0ICAgICAgICAgICA0NTMKKyNkZWZpbmUg
X19OUl9saW5rYXQgICAgICAgICAgICAgNDU0CisjZGVmaW5lIF9fTlJfc3ltbGlua2F0ICAg
ICAgICAgIDQ1NQorI2RlZmluZSBfX05SX3JlYWRsaW5rYXQgICAgICAgICA0NTYKKyNkZWZp
bmUgX19OUl9mY2htb2RhdCAgICAgICAgICAgNDU3CisjZGVmaW5lIF9fTlJfZmFjY2Vzc2F0
ICAgICAgICAgIDQ1OAorI2RlZmluZSBfX05SX3BzZWxlY3Q2ICAgICAgICAgICA0NTkKKyNk
ZWZpbmUgX19OUl9wcG9sbCAgICAgICAgICAgICAgNDYwCisjZGVmaW5lIF9fTlJfdW5zaGFy
ZSAgICAgICAgICAgIDQ2MQorI2RlZmluZSBfX05SX3NldF9yb2J1c3RfbGlzdCAgICA0NjIK
KyNkZWZpbmUgX19OUl9nZXRfcm9idXN0X2xpc3QgICAgNDYzCisjZGVmaW5lIF9fTlJfc3Bs
aWNlICAgICAgICAgICAgIDQ2NAorI2RlZmluZSBfX05SX3N5bmNfZmlsZV9yYW5nZSAgICA0
NjUKKyNkZWZpbmUgX19OUl90ZWUgICAgICAgICAgICAgICAgNDY2CisKICNpZmRlZiBfX0tF
Uk5FTF9fCiAKLSNkZWZpbmUgTlJfU1lTQ0FMTFMJCQk0NDcKKyNkZWZpbmUgTlJfU1lTQ0FM
TFMJCQk0NjcKIAogI2RlZmluZSBfX0FSQ0hfV0FOVF9JUENfUEFSU0VfVkVSU0lPTgogI2Rl
ZmluZSBfX0FSQ0hfV0FOVF9PTERfUkVBRERJUgotLS0gbGludXgtMi42LjIxL2FyY2gvYWxw
aGEva2VybmVsL3N5c3RibHMuUy5taXNzaW5nX2RlZmluZXMJMjAwNy0wNS0xNiAxMTozMjoy
OS4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4LTIuNi4yMS9hcmNoL2FscGhhL2tlcm5lbC9z
eXN0YmxzLlMJMjAwNy0wNS0xNiAxMTozMDozNi4wMDAwMDAwMDAgKzAyMDAKQEAgLTQ2NSw2
ICs0NjUsMjYgQEAKIAkucXVhZCBzeXNfaW5vdGlmeV9pbml0CiAJLnF1YWQgc3lzX2lub3Rp
ZnlfYWRkX3dhdGNoCQkvKiA0NDUgKi8KIAkucXVhZCBzeXNfaW5vdGlmeV9ybV93YXRjaAor
CS5xdWFkIHN5c19vcGVuYXQKKwkucXVhZCBzeXNfbWtkaXJhdAorCS5xdWFkIHN5c19ta25v
ZGF0CisJLnF1YWQgc3lzX2ZjaG93bmF0CQkJLyogNDUwICovCisJLnF1YWQgc3lzX2Z1dGlt
ZXNhdAorCS5xdWFkIHN5c191bmxpbmthdAorCS5xdWFkIHN5c19yZW5hbWVhdAorCS5xdWFk
IHN5c19saW5rYXQKKwkucXVhZCBzeXNfc3ltbGlua2F0CQkJLyogNDU1ICovCisJLnF1YWQg
c3lzX3JlYWRsaW5rYXQKKwkucXVhZCBzeXNfZmNobW9kYXQKKwkucXVhZCBzeXNfZmFjY2Vz
c2F0CisJLnF1YWQgc3lzX3BzZWxlY3Q2CisJLnF1YWQgc3lzX3Bwb2xsCQkJCS8qIDQ2MCAq
LworCS5xdWFkIHN5c191bnNoYXJlCisJLnF1YWQgc3lzX3NldF9yb2J1c3RfbGlzdAorCS5x
dWFkIHN5c19nZXRfcm9idXN0X2xpc3QKKwkucXVhZCBzeXNfc3BsaWNlCisJLnF1YWQgc3lz
X3N5bmNfZmlsZV9yYW5nZQorCS5xdWFkIHN5c190ZWUKIAogCS5zaXplIHN5c19jYWxsX3Rh
YmxlLCAuIC0gc3lzX2NhbGxfdGFibGUKIAkudHlwZSBzeXNfY2FsbF90YWJsZSwgQG9iamVj
dAo=
--------------070607000906090002000009--
