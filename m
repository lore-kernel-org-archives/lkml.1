Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbXFJEK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbXFJEK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 00:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXFJEKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 00:10:52 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:42568 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbXFJEKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 00:10:52 -0400
Date: Sat, 9 Jun 2007 21:10:51 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: William Lee Irwin III <wli@holomorphy.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adam Litke <agl@us.ibm.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 numa policy and huge pages not working
In-Reply-To: <20070516061259.GZ19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org>
 <20070516061259.GZ19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="500119290-1537669083-1181448651=:10324"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--500119290-1537669083-1181448651=:10324
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 15 May 2007, William Lee Irwin III wrote:

> On Tue, May 15, 2007 at 10:41:06PM -0700, dean gaudet wrote:
> > prior to 2.6.21 i could "numactl --interleave=all" and use SHM_HUGETLB and 
> > the interleave policy would be respected.  as of 2.6.21 it doesn't seem to 
> > respect the policy on SHM_HUGETLB request.
> > see test program below.
> > output from pre-2.6.21:
> > 2ab196200000 interleave=0-3 file=/2\040(deleted) huge dirty=32 N0=8 N1=8 N2=8 N3=8
> > 2ab19a200000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096
> > output from 2.6.21:
> > 2b49b1c00000 default file=/10\040(deleted) huge dirty=32 N3=32
> > 2b49b5c00000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096
> > was this an intentional behaviour change?  it seems to be only affecting 
> > SHM_HUGETLB allocations.  (i haven't tested hugetlbfs yet.)
> > run with "numactl --interleave=all ./shmtest"
> 
> This was not intentional. I'll search for where it broke.

ok i've narrowed it some... maybe.

in commit 8ef8286689c6b5bc76212437b85bdd2ba749ee44 things work fine, numa 
policy is respected...

the very next commit bc56bba8f31bd99f350a5ebfd43d50f411b620c7 breaks shm 
badly causing the test program to oops the kernel.

commit 516dffdcd8827a40532798602830dfcfc672294c fixes that breakage but 
numa policy is no longer respected.

i've added the authors of those two commits to the recipient list and 
reattached the test program.  hopefully someone can shed light on the 
problem.

-dean
--500119290-1537669083-1181448651=:10324
Content-Type: TEXT/x-csrc; charset=US-ASCII; name=shmtest.c
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=shmtest.c

I2luY2x1ZGUgPHN5cy9tbWFuLmg+DQojaW5jbHVkZSA8c3lzL2lwYy5oPg0K
I2luY2x1ZGUgPHN5cy9zaG0uaD4NCiNpbmNsdWRlIDxzdGRpby5oPg0KI2lu
Y2x1ZGUgPHVuaXN0ZC5oPg0KI2luY2x1ZGUgPHN0cmluZy5oPg0KI2luY2x1
ZGUgPHN0ZGxpYi5oPg0KDQoNCnN0YXRpYyB2b2lkICphbGxvY19hcmVuYV9z
aG0oc2l6ZV90IGFyZW5hX3NpemUsIHVuc2lnbmVkIGZsYWdzKQ0Kew0KCUZJ
TEUgKmZoOw0KCWNoYXIgYnVmWzUxMl07DQoJc2l6ZV90IGh1Z2VfcGFnZV9z
aXplOw0KCWNoYXIgKnA7DQoJaW50IHNobWlkOw0KCXZvaWQgKmFyZW5hOw0K
DQoJLy8gZmluZCBIdWdlcGFnZXNpemUgaW4gL3Byb2MvbWVtaW5mbw0KCWlm
ICgoZmggPSBmb3BlbigiL3Byb2MvbWVtaW5mbyIsICJyIikpID09IE5VTEwp
IHsNCgkJcGVycm9yKCJvcGVuKC9wcm9jL21lbWluZm8pIik7DQoJCWV4aXQo
MSk7DQoJfQ0KCWZvciAoOzspIHsNCgkJaWYgKGZnZXRzKGJ1Ziwgc2l6ZW9m
KGJ1ZiktMSwgZmgpID09IE5VTEwpIHsNCgkJCWZwcmludGYoc3RkZXJyLCAi
ZGlkbid0IGZpbmQgSHVnZXBhZ2VzaXplIGluIC9wcm9jL21lbWluZm8iKTsN
CgkJCWV4aXQoMSk7DQoJCX0NCgkJYnVmW3NpemVvZihidWYpLTFdID0gJ1ww
JzsNCgkJaWYgKHN0cm5jbXAoYnVmLCAiSHVnZXBhZ2VzaXplOiIsIDEzKSA9
PSAwKSBicmVhazsNCgl9DQoJcCA9IHN0cmNocihidWYsICc6JykgKyAxOw0K
CWh1Z2VfcGFnZV9zaXplID0gc3RydG91bChwLCAwLCAwKSAqIDEwMjQ7DQoJ
ZmNsb3NlKGZoKTsNCg0KCS8vIHJvdW5kIHRoZSBzaXplIHVwIHRvIG11bHRp
cGxlIG9mIGh1Z2VfcGFnZV9zaXplDQoJYXJlbmFfc2l6ZSA9IChhcmVuYV9z
aXplICsgaHVnZV9wYWdlX3NpemUgLSAxKSAmIH4oaHVnZV9wYWdlX3NpemUg
LSAxKTsNCg0KCXNobWlkID0gc2htZ2V0KElQQ19QUklWQVRFLCBhcmVuYV9z
aXplLCBJUENfQ1JFQVR8SVBDX0VYQ0x8ZmxhZ3N8MDYwMCk7DQoJaWYgKHNo
bWlkID09IC0xKSB7DQoJCXBlcnJvcigic2htZ2V0Iik7DQoJCWV4aXQoMSk7
DQoJfQ0KDQoJYXJlbmEgPSBzaG1hdChzaG1pZCwgTlVMTCwgMCk7DQoJaWYg
KGFyZW5hID09ICh2b2lkICopLTEpIHsNCgkJcGVycm9yKCJzaG1hdCIpOw0K
CQlleGl0KDEpOw0KCX0NCg0KCWlmIChzaG1jdGwoc2htaWQsIElQQ19STUlE
LCAwKSA9PSAtMSkgew0KCQlwZXJyb3IoInNobWN0bCB3YXJuaW5nIik7DQoJ
fQ0KDQoJcmV0dXJuIGFyZW5hOw0KfQ0KDQppbnQgbWFpbihpbnQgYXJnYywg
Y2hhciAqKmFyZ3YpDQp7DQogICAgICAgIGNoYXIgYnVmWzEwMjRdOw0KICAg
ICAgICBjb25zdCBzaXplX3Qgc3ogPSA2NCoxMDI0KjEwMjQ7DQogICAgICAg
IHZvaWQgKmFyZW5hID0gYWxsb2NfYXJlbmFfc2htKHN6LCBTSE1fSFVHRVRM
Qik7DQogICAgICAgIG1lbXNldChhcmVuYSwgMCwgc3opOw0KICAgICAgICBz
bnByaW50ZihidWYsIHNpemVvZihidWYpLCAiZ3JlcCBeJWxseCAvcHJvYy8l
ZC9udW1hX21hcHMiLCAodW5zaWduZWQgbG9uZyBsb25nKWFyZW5hLCAoaW50
KWdldHBpZCgpKTsNCiAgICAgICAgc3lzdGVtKGJ1Zik7DQoNCiAgICAgICAg
YXJlbmEgPSBhbGxvY19hcmVuYV9zaG0oc3osIDApOw0KICAgICAgICBtZW1z
ZXQoYXJlbmEsIDAsIHN6KTsNCiAgICAgICAgc25wcmludGYoYnVmLCBzaXpl
b2YoYnVmKSwgImdyZXAgXiVsbHggL3Byb2MvJWQvbnVtYV9tYXBzIiwgKHVu
c2lnbmVkIGxvbmcgbG9uZylhcmVuYSwgKGludClnZXRwaWQoKSk7DQogICAg
ICAgIHN5c3RlbShidWYpOw0KDQogICAgICAgIHJldHVybiAwOw0KfQ0K

--500119290-1537669083-1181448651=:10324--
