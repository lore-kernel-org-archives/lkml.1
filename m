Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbXFTPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbXFTPOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbXFTPO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:14:27 -0400
Received: from dovecot.org ([82.118.211.50]:46050 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbXFTPO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:14:26 -0400
X-Greylist: delayed 1291 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2007 11:14:26 EDT
Subject: SMP read() stopping at memory page boundaries
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QwhZTMIJLP1sAjnzD6J/"
Date: Wed, 20 Jun 2007 17:52:51 +0300
Message-Id: <1182351171.3768.65.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QwhZTMIJLP1sAjnzD6J/
Content-Type: multipart/mixed; boundary="=-I7UeBDJ24wJSLnuYFQvv"


--=-I7UeBDJ24wJSLnuYFQvv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Tested with various 2.6.x i386/x86-64 SMP kernels and CPUs, for example
2.6.21.3/x86-64.

Process 1:

 - lock file
 - write(4096 + 16 bytes)
 - unlock file

Process 2:

 - lock file
 - read(8192 bytes)
 - unlock file

Sometimes read() returns only 4096 bytes. I'm locking the file, so I
don't think this should ever happen, right?

Attached a test program. Takes from a few seconds to half a minute with
my computer to print "page size cut".


--=-I7UeBDJ24wJSLnuYFQvv
Content-Disposition: attachment; filename=concurrency2.c
Content-Type: text/x-csrc; name=concurrency2.c; charset=ISO-8859-15
Content-Transfer-Encoding: base64

LyoNCiAgIGdjYyBjb25jdXJyZW5jeTIuYyAtbyBjb25jdXJyZW5jeSAtV2FsbA0KDQogICBzdGFy
dCB0d28gYm90aCBhIHJlYWRlciBhbmQgYSB3cml0ZXI6DQoNCiAgIC4vY29uY3VycmVuY3kNCiAg
IC4vY29uY3VycmVuY3kgMQ0KKi8NCiNpbmNsdWRlIDxzdGRpby5oPg0KI2luY2x1ZGUgPHN0ZGxp
Yi5oPg0KI2luY2x1ZGUgPHN0cmluZy5oPg0KI2luY2x1ZGUgPGZjbnRsLmg+DQojaW5jbHVkZSA8
dW5pc3RkLmg+DQojaW5jbHVkZSA8YXNzZXJ0Lmg+DQojaW5jbHVkZSA8c3lzL2ZpbGUuaD4NCg0K
I2RlZmluZSBNQVhfUEFHRVNJWkUgODE5Mg0KDQppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJn
dltdKQ0Kew0KCWNoYXIgYnVmW01BWF9QQUdFU0laRSoyXTsNCglpbnQgZmQsIHJldCwgcGFnZXNp
emU7DQoNCgltZW1zZXQoYnVmLCAwLCBzaXplb2YoYnVmKSk7DQoNCglwYWdlc2l6ZSA9IGdldHBh
Z2VzaXplKCk7DQoJYXNzZXJ0KHBhZ2VzaXplIDw9IE1BWF9QQUdFU0laRSk7DQoNCglidWZbcGFn
ZXNpemVdID0gJ2gnOw0KCWlmIChhcmdjID09IDEpIHsNCgkJcHJpbnRmKCJ3cml0aW5nLCBwYWdl
IHNpemUgPSAlZFxuIiwgcGFnZXNpemUpOw0KCQlmb3IgKDs7KSB7DQoJCQlmZCA9IG9wZW4oImZv
byIsIE9fUkRXUiB8IE9fQ1JFQVQgfCBPX1RSVU5DLCAwNjAwKTsNCgkJCWlmIChmZCA9PSAtMSkg
ew0KCQkJCXBlcnJvcigib3BlbigpIik7DQoJCQkJcmV0dXJuIDE7DQoJCQl9DQoNCgkJCWlmIChm
bG9jayhmZCwgTE9DS19FWCkgPCAwKQ0KCQkJCXBlcnJvcigiZmxvY2soKSIpOw0KCQkJd3JpdGUo
ZmQsIGJ1ZiwgcGFnZXNpemUrMTYpOw0KCQkJaWYgKGZsb2NrKGZkLCBMT0NLX1VOKSA8IDApDQoJ
CQkJcGVycm9yKCJmbG9jaygpIik7DQoJCQl1c2xlZXAocmFuZCgpICUgMTAwMCk7DQoJCQljbG9z
ZShmZCk7DQoJCX0NCgl9IGVsc2Ugew0KCQlwcmludGYoInJlYWRpbmcsIHBhZ2Ugc2l6ZSA9ICVk
XG4iLCBwYWdlc2l6ZSk7DQoJCWZkID0gb3BlbigiZm9vIiwgT19SRFdSLCAwNjAwKTsNCgkJaWYg
KGZkID09IC0xKSB7DQoJCQlwZXJyb3IoIm9wZW4oKSIpOw0KCQkJcmV0dXJuIDE7DQoJCX0NCgkJ
Zm9yICg7Oykgew0KCQkJdXNsZWVwKHJhbmQoKSAlIDEwMDApOw0KCQkJaWYgKGZsb2NrKGZkLCBM
T0NLX1NIKSA8IDApDQoJCQkJcGVycm9yKCJmbG9jaygpIik7DQoJCQlsc2VlayhmZCwgMCwgU0VF
S19TRVQpOw0KCQkJcmV0ID0gcmVhZChmZCwgYnVmLCBzaXplb2YoYnVmKSk7DQoJCQlpZiAoZmxv
Y2soZmQsIExPQ0tfVU4pIDwgMCkNCgkJCQlwZXJyb3IoImZsb2NrKCkiKTsNCg0KCQkJaWYgKHJl
dCA8IHBhZ2VzaXplKSB7DQoJCQkJaWYgKHJldCA+IDApDQoJCQkJCXByaW50ZigibGVzcyB0aGFu
IGEgcGFnZTogJWRcbiIsIHJldCk7DQoJCQl9IGVsc2UgaWYgKHJldCA9PSBwYWdlc2l6ZSkgew0K
CQkJCXByaW50ZigicGFnZSBzaXplIGN1dFxuIik7DQoJCQl9IGVsc2UgaWYgKGJ1ZltwYWdlc2l6
ZV0gIT0gJ2gnKSB7DQoJCQkJcHJpbnRmKCJicm9rZW4gZGF0YVxuIik7DQoJCQl9DQoJCX0NCgl9
DQoJcmV0dXJuIDA7DQp9DQo=


--=-I7UeBDJ24wJSLnuYFQvv--

--=-QwhZTMIJLP1sAjnzD6J/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGeT9DyUhSUUBViskRAvUXAKCkZnnWlw/6n5+A6ABEWBux3f6C/gCfbujh
QgdksT/aZHqiBlznmlGluso=
=hPyw
-----END PGP SIGNATURE-----

--=-QwhZTMIJLP1sAjnzD6J/--

