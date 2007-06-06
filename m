Return-Path: <linux-kernel-owner+w=401wt.eu-S934700AbXFFT1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934700AbXFFT1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXFFT1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:27:03 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:47431 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763290AbXFFT1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:27:00 -0400
X-Greylist: delayed 1040 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 15:27:00 EDT
Message-ID: <466705F5.9000702@opcode-solutions.com>
Date: Wed, 06 Jun 2007 20:07:33 +0100
From: Matt Keenan <matt@opcode-solutions.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Steve French <sfrench@samba.org>
CC: Jeremy Allison <jra@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-cifs-client@lists.samba.org
Subject: [PATCH] CIFS should honour umask
Content-Type: multipart/mixed;
 boundary="------------000206070705030701060406"
X-Originating-Heisenberg-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000206070705030701060406
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch makes CIFS honour a process' umask like other filesystems. 
Of course the server is still free to munge the permissions if it wants
to; but the client will send the "right" permissions to begin with.

A few caveats;

1) It only applies to filesystems that have CAP_UNIX (aka support unix
extensions)
2) It applies the correct mode to the follow up CIFSSMBUnixSetPerms()
after remote creation (I can write a new patch if you want with the
"right" mode at actual creation time; however the "right" perms will
still need to be given to the follow up CIFSSMBUnixSetPerms() anyway).
3) It will probably work best with Samba 3.0.25a or newer (ie with this
patch applied
http://lists.samba.org/archive/linux-cifs-client/2007-January/001697.html)
4) It has been compiled, and tested on 2.6.22-rc4 / Samba 3.0.25a
(Ubuntu Dapper with a few custom backports), and with a bit of testing
seems to work just fine. (it also incidentally side steps bugs in
thunderbird and openoffice (the apps don't check the permissions on
files they create, they assume they will open() the way that have asked
them to be created xref open(O_WRONLY|O_CREAT) => valid fd then
mmap(fd,PROT_READ) => EFAULT).

I am going to give this patch a more thorough test tomorrow with ltp.
Comments, corrections, et al are welcome.


Matt

-- 
Matt Keenan
OpCode Solutions



--------------000206070705030701060406
Content-Type: text/plain;
 name="patch-2.6.22-rc4.cifs-umask-fix"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="patch-2.6.22-rc4.cifs-umask-fix"

U2lnbmVkLW9mZi1ieTogTWF0dCBLZWVuYW4gPG1hdHRAb3Bjb2RlLXNvbHV0aW9ucy5jb20+
CgotLQpkaWZmIC11ck4gbGludXgtMi42LjIyLXJjNC9mcy9jaWZzL2Rpci5jIGxpbnV4LTIu
Ni4yMi1yYzQuY2lmcy11bWFzay1maXgvZnMvY2lmcy9kaXIuYwotLS0gbGludXgtMi42LjIy
LXJjNC9mcy9jaWZzL2Rpci5jCTIwMDctMDYtMDYgMDg6MzQ6MDMuMDAwMDAwMDAwICswMTAw
CisrKyBsaW51eC0yLjYuMjItcmM0LmNpZnMtdW1hc2stZml4L2ZzL2NpZnMvZGlyLmMJMjAw
Ny0wNi0wNiAxOToyNzowMC4wMDAwMDAwMDAgKzAxMDAKQEAgLTIwNiw3ICsyMDYsMTEgQEAK
IAkJLyogSWYgT3BlbiByZXBvcnRlZCB0aGF0IHdlIGFjdHVhbGx5IGNyZWF0ZWQgYSBmaWxl
CiAJCXRoZW4gd2Ugbm93IGhhdmUgdG8gc2V0IHRoZSBtb2RlIGlmIHBvc3NpYmxlICovCiAJ
CWlmICgoY2lmc19zYi0+dGNvbi0+c2VzLT5jYXBhYmlsaXRpZXMgJiBDQVBfVU5JWCkgJiYK
LQkJCShvcGxvY2sgJiBDSUZTX0NSRUFURV9BQ1RJT04pKQorCQkJKG9wbG9jayAmIENJRlNf
Q1JFQVRFX0FDVElPTikpIHsKKwkJCS8qIHJlc3BlY3QgdW1hc2sgc2V0dGluZ3MgbGlrZSBv
dGhlciBmaWxlc3lzdGVtczsKKwkJCSAqIGlmIHRoZSBzZXJ2ZXIgd2FudHMgdG8gbXVuZ2Ug
dGhlIGJpdHMgbGV0IGl0LCBidXQgdGhlIGNsaWVudAorCQkJICogc2hvdWxkICJEbyBUaGUg
UmlnaHQgVGhpbmciICh0bSkgKi8KKwkJCW1vZGUgJj0gfmN1cnJlbnQtPmZzLT51bWFzazsK
IAkJCWlmKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9TRVRfVUlEKSB7
CiAJCQkJQ0lGU1NNQlVuaXhTZXRQZXJtcyh4aWQsIHBUY29uLCBmdWxsX3BhdGgsIG1vZGUs
CiAJCQkJCShfX3U2NCljdXJyZW50LT5mc3VpZCwKQEAgLTIyNCw3ICsyMjgsNyBAQAogCQkJ
CQljaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIAogCQkJCQkJQ0lGU19NT1VOVF9NQVBfU1BF
Q0lBTF9DSFIpOwogCQkJfQotCQllbHNlIHsKKwkJfSBlbHNlIHsKIAkJCS8qIEJCIGltcGxl
bWVudCBtb2RlIHNldHRpbmcgdmlhIFdpbmRvd3Mgc2VjdXJpdHkgZGVzY3JpcHRvcnMgKi8K
IAkJCS8qIGVnIENJRlNTTUJXaW5TZXRQZXJtcyh4aWQscFRjb24sZnVsbF9wYXRoLG1vZGUs
LTEsLTEsbG9jYWxfbmxzKTsqLwogCQkJLyogY291bGQgc2V0IHIvbyBkb3MgYXR0cmlidXRl
IGlmIG1vZGUgJiAwMjIyID09IDAgKi8KZGlmZiAtdXJOIGxpbnV4LTIuNi4yMi1yYzQvZnMv
Y2lmcy9pbm9kZS5jIGxpbnV4LTIuNi4yMi1yYzQuY2lmcy11bWFzay1maXgvZnMvY2lmcy9p
bm9kZS5jCi0tLSBsaW51eC0yLjYuMjItcmM0L2ZzL2NpZnMvaW5vZGUuYwkyMDA3LTA2LTA2
IDA4OjM0OjAzLjAwMDAwMDAwMCArMDEwMAorKysgbGludXgtMi42LjIyLXJjNC5jaWZzLXVt
YXNrLWZpeC9mcy9jaWZzL2lub2RlLmMJMjAwNy0wNi0wNiAxOToyNjoyNi4wMDAwMDAwMDAg
KzAxMDAKQEAgLTk4Nyw2ICs5ODcsMTEgQEAKIAkJaWYgKChkaXJlbnRyeS0+ZF9pbm9kZSkg
JiYgKGRpcmVudHJ5LT5kX2lub2RlLT5pX25saW5rIDwgMikpCiAJCQkJZGlyZW50cnktPmRf
aW5vZGUtPmlfbmxpbmsgPSAyOyAKIAkJaWYgKGNpZnNfc2ItPnRjb24tPnNlcy0+Y2FwYWJp
bGl0aWVzICYgQ0FQX1VOSVgpCisJCXsKKwkJCS8qIHJlc3BlY3QgdW1hc2sgc2V0dGluZ3Mg
bGlrZSBvdGhlciBmaWxlc3lzdGVtczsKKwkJCSAqIGlmIHRoZSBzZXJ2ZXIgd2FudHMgdG8g
bXVuZ2UgdGhlIGJpdHMgbGV0IGl0LCBidXQgdGhlIGNsaWVudAorCQkJICogc2hvdWxkICJE
byBUaGUgUmlnaHQgVGhpbmciICh0bSkgKi8KKwkJCW1vZGUgJj0gfmN1cnJlbnQtPmZzLT51
bWFzazsKIAkJCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfU0VU
X1VJRCkgewogCQkJCUNJRlNTTUJVbml4U2V0UGVybXMoeGlkLCBwVGNvbiwgZnVsbF9wYXRo
LAogCQkJCQkJICAgIG1vZGUsCkBAIC0xMDA0LDcgKzEwMDksNyBAQAogCQkJCQkJICAgIGNp
ZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgCiAJCQkJCQkgICAgQ0lGU19NT1VOVF9NQVBfU1BF
Q0lBTF9DSFIpOwogCQkJfQotCQllbHNlIHsKKwkJfSBlbHNlIHsKIAkJCS8qIEJCIHRvIGJl
IGltcGxlbWVudGVkIHZpYSBXaW5kb3dzIHNlY3J0eSBkZXNjcmlwdG9ycwogCQkJICAgZWcg
Q0lGU1NNQldpblNldFBlcm1zKHhpZCwgcFRjb24sIGZ1bGxfcGF0aCwgbW9kZSwKIAkJCQkJ
CSAtMSwgLTEsIGxvY2FsX25scyk7ICovCg==
--------------000206070705030701060406--
