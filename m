Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZDUWcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZDUWcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZDUWbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:31:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:39747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZDUWbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:31:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,226,1239001200"; 
   d="scan'208";a="508622621"
From: "Luck, Tony" <tony.luck@intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux.com>, Nick Piggin <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "iwamatsu.nobuhiro@renesas.com" <iwamatsu.nobuhiro@renesas.com>
Date: Tue, 21 Apr 2009 15:31:50 -0700
Subject: RE: linux-next ia64 build problems in slqb
Thread-Topic: linux-next ia64 build problems in slqb
Thread-Index: AcnCtGNkXgHeb69KRqORCKwY9jnHmQAEqUyQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39EC57AB7@orsmsx505.amr.corp.intel.com>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
	 <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com>
	 <alpine.DEB.1.10.0904211034550.19969@qirst.com>
	 <84144f020904211125v68b98df4ke1c04bc29df65fda@mail.gmail.com>
	 <57C9024A16AD2D4C97DC78E552063EA39EC57748@orsmsx505.amr.corp.intel.com>
 <84144f020904211207q736bfc44n4cd622536cd0a67@mail.gmail.com>
In-Reply-To: <84144f020904211207q736bfc44n4cd622536cd0a67@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_57C9024A16AD2D4C97DC78E552063EA39EC57AB7orsmsx505amrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_57C9024A16AD2D4C97DC78E552063EA39EC57AB7orsmsx505amrcor_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> > I'm trying to check whether http://lkml.org/lkml/2009/4/20/30
> > fixes things.  It certainly solves the complilation problem,
> > but I'm running into apparently unrelated issues trying to
> > boot linux-next kernels.

My unrelated issue was the new default for CONFIG_SYSFS_DEPRECATED
(since my test machine does have an old distribution, this change
upset my old udev tools and I ended up with no /dev/root :-( )

Turning that back on, the CONFIG_SLQB=3Dy version booted with no
obvious problems.

> Great! You can try it on top of the "topic/slqb/core" branch of
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git
>
> if you want. It's basically plain 2.6.30-rc1 plus SLQB.

Since I got linux-next up & running, I didn't need to try this.

> One minor nit: the patch should define an empty static inline of
> claim_remote_free_list() for the !SMP case. I can fix it at my end
> before merging, though, if necessary.

Agreed.  It would be better to have an empty static inline than
adding the noisy #ifdef SMP around every call to
claim_remote_free_list() ... in fact some such #ifdef can be
removed.

You could tag such a modified patch (attached) as:

Acked-by: Tony Luck <tony.luck@intel.com>

-Tony

--_002_57C9024A16AD2D4C97DC78E552063EA39EC57AB7orsmsx505amrcor_
Content-Type: application/octet-stream; name="fix-slqb-numa-up-build.patch"
Content-Description: fix-slqb-numa-up-build.patch
Content-Disposition: attachment; filename="fix-slqb-numa-up-build.patch";
	size=2283; creation-date="Tue, 21 Apr 2009 15:28:57 GMT";
	modification-date="Tue, 21 Apr 2009 15:28:57 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL21tL3NscWIuYyBiL21tL3NscWIuYwppbmRleCAzNzk0OWY1Li41MGJmMTgw
IDEwMDY0NAotLS0gYS9tbS9zbHFiLmMKKysrIGIvbW0vc2xxYi5jCkBAIC0xMjI0LDYgKzEyMjQs
MTEgQEAgc3RhdGljIHZvaWQgY2xhaW1fcmVtb3RlX2ZyZWVfbGlzdChzdHJ1Y3Qga21lbV9jYWNo
ZSAqcywKIAlzbHFiX3N0YXRfaW5jKGwsIENMQUlNX1JFTU9URV9MSVNUKTsKIAlzbHFiX3N0YXRf
YWRkKGwsIENMQUlNX1JFTU9URV9MSVNUX09CSkVDVFMsIG5yKTsKIH0KKyNlbHNlCitzdGF0aWMg
aW5saW5lIHZvaWQgY2xhaW1fcmVtb3RlX2ZyZWVfbGlzdChzdHJ1Y3Qga21lbV9jYWNoZSAqcywK
KwkJCQkJc3RydWN0IGttZW1fY2FjaGVfbGlzdCAqbCkKK3sKK30KICNlbmRpZgogCiAvKgpAQCAt
MTcyOCw3ICsxNzMzLDcgQEAgc3RhdGljIF9fYWx3YXlzX2lubGluZSB2b2lkIF9fc2xhYl9mcmVl
KHN0cnVjdCBrbWVtX2NhY2hlICpzLAogCQkJZmx1c2hfZnJlZV9saXN0KHMsIGwpOwogCiAJfSBl
bHNlIHsKLSNpZmRlZiBDT05GSUdfTlVNQQorI2lmZGVmIENPTkZJR19TTVAKIAkJLyoKIAkJICog
RnJlZWluZyBhbiBvYmplY3QgdGhhdCB3YXMgYWxsb2NhdGVkIG9uIGEgcmVtb3RlIG5vZGUuCiAJ
CSAqLwpAQCAtMTkzNyw3ICsxOTQyLDkgQEAgc3RhdGljIERFRklORV9QRVJfQ1BVKHN0cnVjdCBr
bWVtX2NhY2hlX25vZGUsIGttZW1fY3B1X25vZGVzKTsgLyogWFhYIHBlci1uaWQgKi8KIAogI2lm
ZGVmIENPTkZJR19OVU1BCiBzdGF0aWMgc3RydWN0IGttZW1fY2FjaGUga21lbV9ub2RlX2NhY2hl
OworIyBpZmRlZiBDT05GSUdfU01QCiBzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IGttZW1f
Y2FjaGVfY3B1LCBrbWVtX25vZGVfY3B1cyk7CisjIGVuZGlmCiBzdGF0aWMgREVGSU5FX1BFUl9D
UFUoc3RydWN0IGttZW1fY2FjaGVfbm9kZSwga21lbV9ub2RlX25vZGVzKTsgLypYWFggcGVyLW5p
ZCAqLwogI2VuZGlmCiAKQEAgLTIyNzAsNyArMjI3Nyw3IEBAIHN0YXRpYyBpbnQga21lbV9jYWNo
ZV9vcGVuKHN0cnVjdCBrbWVtX2NhY2hlICpzLAogZXJyb3Jfbm9kZXM6CiAJZnJlZV9rbWVtX2Nh
Y2hlX25vZGVzKHMpOwogZXJyb3Jfbm9kZV9hcnJheToKLSNpZmRlZiBDT05GSUdfTlVNQQorI2lm
IGRlZmluZWQoQ09ORklHX05VTUEpICYmIGRlZmluZWQoQ09ORklHX1NNUCkKIAlrbWVtX2NhY2hl
X2R5bl9hcnJheV9mcmVlKHMtPm5vZGVfc2xhYik7CiBlcnJvcl9jcHVfYXJyYXk6CiAjZW5kaWYK
QEAgLTIzNzAsOSArMjM3Nyw3IEBAIHZvaWQga21lbV9jYWNoZV9kZXN0cm95KHN0cnVjdCBrbWVt
X2NhY2hlICpzKQogCQlzdHJ1Y3Qga21lbV9jYWNoZV9jcHUgKmMgPSBnZXRfY3B1X3NsYWIocywg
Y3B1KTsKIAkJc3RydWN0IGttZW1fY2FjaGVfbGlzdCAqbCA9ICZjLT5saXN0OwogCi0jaWZkZWYg
Q09ORklHX1NNUAogCQljbGFpbV9yZW1vdGVfZnJlZV9saXN0KHMsIGwpOwotI2VuZGlmCiAJCWZs
dXNoX2ZyZWVfbGlzdF9hbGwocywgbCk7CiAKIAkJV0FSTl9PTihsLT5mcmVlbGlzdC5ucik7CkBA
IC0yNTk1LDkgKzI2MDAsNyBAQCBzdGF0aWMgdm9pZCBrbWVtX2NhY2hlX3RyaW1fcGVyY3B1KHZv
aWQgKmFyZykKIAlzdHJ1Y3Qga21lbV9jYWNoZV9jcHUgKmMgPSBnZXRfY3B1X3NsYWIocywgY3B1
KTsKIAlzdHJ1Y3Qga21lbV9jYWNoZV9saXN0ICpsID0gJmMtPmxpc3Q7CiAKLSNpZmRlZiBDT05G
SUdfU01QCiAJY2xhaW1fcmVtb3RlX2ZyZWVfbGlzdChzLCBsKTsKLSNlbmRpZgogCWZsdXNoX2Zy
ZWVfbGlzdChzLCBsKTsKICNpZmRlZiBDT05GSUdfU01QCiAJZmx1c2hfcmVtb3RlX2ZyZWVfY2Fj
aGUocywgYyk7CkBAIC0yODgxLDExICsyODg0LDExIEBAIHZvaWQgX19pbml0IGttZW1fY2FjaGVf
aW5pdCh2b2lkKQogCQluID0gJnBlcl9jcHUoa21lbV9jYWNoZV9ub2RlcywgaSk7CiAJCWluaXRf
a21lbV9jYWNoZV9ub2RlKCZrbWVtX2NhY2hlX2NhY2hlLCBuKTsKIAkJa21lbV9jYWNoZV9jYWNo
ZS5ub2RlX3NsYWJbaV0gPSBuOwotCisjaWZkZWYgQ09ORklHX1NNUAogCQluID0gJnBlcl9jcHUo
a21lbV9jcHVfbm9kZXMsIGkpOwogCQlpbml0X2ttZW1fY2FjaGVfbm9kZSgma21lbV9jcHVfY2Fj
aGUsIG4pOwogCQlrbWVtX2NwdV9jYWNoZS5ub2RlX3NsYWJbaV0gPSBuOwotCisjZW5kaWYKIAkJ
biA9ICZwZXJfY3B1KGttZW1fbm9kZV9ub2RlcywgaSk7CiAJCWluaXRfa21lbV9jYWNoZV9ub2Rl
KCZrbWVtX25vZGVfY2FjaGUsIG4pOwogCQlrbWVtX25vZGVfY2FjaGUubm9kZV9zbGFiW2ldID0g
bjsK

--_002_57C9024A16AD2D4C97DC78E552063EA39EC57AB7orsmsx505amrcor_--
