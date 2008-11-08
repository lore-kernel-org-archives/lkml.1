Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYKHH5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYKHH5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 02:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYKHH5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 02:57:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:11513 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYKHH5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 02:57:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,568,1220252400"; 
   d="scan'208,223";a="460688292"
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "avi@qumranet.com" <avi@qumranet.com>
Date: Sat, 8 Nov 2008 15:57:00 +0800
Subject: RE: next-20081107: ia64 vs kvm
Thread-Topic: next-20081107: ia64 vs kvm
Thread-Index: AclBJ+/8cxhJS2EARZSpI62WcS5yJwATy41g
Message-ID: <706158FABBBA044BAD4FE898A02E4BC21983F9EB@pdsmsx503.ccr.corp.intel.com>
References: <20081107205457.f64dea59.sfr@canb.auug.org.au>
 <20081107223001.GA16733@x200.localdomain>
In-Reply-To: <20081107223001.GA16733@x200.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_706158FABBBA044BAD4FE898A02E4BC21983F9EBpdsmsx503ccrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_706158FABBBA044BAD4FE898A02E4BC21983F9EBpdsmsx503ccrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Alexey Dobriyan wrote:
> On ia64-smp-n-debug-n-preempt-n:
>=20
> arch/ia64/kvm/vmm.c:63: error: 'raw_spinlock_t' has no member named
> 'lock'=20
>=20
Hi, Avi
	This patch should fix the issue Alex met, please apply to kvm.git and queu=
e it for 2.6.28 fixes. Thanks!
Xiantao

>From fae5782b369f4bd6e8edecad5912fea7624f0374 Mon Sep 17 00:00:00 2001
From: Xiantao Zhang <xiantao.zhang@intel.com>
Date: Sat, 8 Nov 2008 15:46:59 +0800
Subject: [PATCH] KVM: IA64: Fix vmm_spin_{un}lock for !CONFIG_SMP.

In the case of !CONFIG_SMP, raw_spinlock_t has no any member
so vmm_spin_lock should also defines the version for !CONFIG_SMP.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
---
 arch/ia64/kvm/vcpu.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/vcpu.h b/arch/ia64/kvm/vcpu.h
index 341e3fe..e9b2a4e 100644
--- a/arch/ia64/kvm/vcpu.h
+++ b/arch/ia64/kvm/vcpu.h
@@ -384,6 +384,10 @@ static inline u64 __gpfn_is_io(u64 gpfn)
 #define MODE_IND(psr)	\
 	(((psr).it << 2) + ((psr).dt << 1) + (psr).rt)
=20
+#ifndef CONFIG_SMP
+#define _vmm_raw_spin_lock(x)	 do {}while(0)
+#define _vmm_raw_spin_unlock(x) do {}while(0)
+#else
 #define _vmm_raw_spin_lock(x)						\
 	do {								\
 		__u32 *ia64_spinlock_ptr =3D (__u32 *) (x);		\
@@ -403,6 +407,7 @@ static inline u64 __gpfn_is_io(u64 gpfn)
 	do { barrier();				\
 		((spinlock_t *)x)->raw_lock.lock =3D 0; } \
 while (0)
+#endif
=20
 void vmm_spin_lock(spinlock_t *lock);
 void vmm_spin_unlock(spinlock_t *lock);
--=20
1.6.0

--_002_706158FABBBA044BAD4FE898A02E4BC21983F9EBpdsmsx503ccrcor_
Content-Type: application/octet-stream;
	name="0001-KVM-IA64-Fix-vmm_spin_-un-lock-for-CONFIG_SMP.patch"
Content-Description: 0001-KVM-IA64-Fix-vmm_spin_-un-lock-for-CONFIG_SMP.patch
Content-Disposition: attachment;
	filename="0001-KVM-IA64-Fix-vmm_spin_-un-lock-for-CONFIG_SMP.patch";
	size=1237; creation-date="Sat, 08 Nov 2008 15:53:35 GMT";
	modification-date="Sat, 08 Nov 2008 15:53:35 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmYWU1NzgyYjM2OWY0YmQ2ZThlZGVjYWQ1OTEyZmVhNzYyNGYwMzc0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBYaWFudGFvIFpoYW5nIDx4aWFudGFvLnpoYW5nQGludGVsLmNv
bT4KRGF0ZTogU2F0LCA4IE5vdiAyMDA4IDE1OjQ2OjU5ICswODAwClN1YmplY3Q6IFtQQVRDSF0g
S1ZNOiBJQTY0OiBGaXggdm1tX3NwaW5fe3VufWxvY2sgZm9yICFDT05GSUdfU01QLgoKSW4gdGhl
IGNhc2Ugb2YgIUNPTkZJR19TTVAsIHJhd19zcGlubG9ja190IGhhcyBubyBhbnkgbWVtYmVyCnNv
IHZtbV9zcGluX2xvY2sgc2hvdWxkIGFsc28gZGVmaW5lcyB0aGUgdmVyc2lvbiBmb3IgIUNPTkZJ
R19TTVAuCgpTaWduZWQtb2ZmLWJ5OiBYaWFudGFvIFpoYW5nIDx4aWFudGFvLnpoYW5nQGludGVs
LmNvbT4KLS0tCiBhcmNoL2lhNjQva3ZtL3ZjcHUuaCB8ICAgIDUgKysrKysKIDEgZmlsZXMgY2hh
bmdlZCwgNSBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gv
aWE2NC9rdm0vdmNwdS5oIGIvYXJjaC9pYTY0L2t2bS92Y3B1LmgKaW5kZXggMzQxZTNmZS4uZTli
MmE0ZSAxMDA2NDQKLS0tIGEvYXJjaC9pYTY0L2t2bS92Y3B1LmgKKysrIGIvYXJjaC9pYTY0L2t2
bS92Y3B1LmgKQEAgLTM4NCw2ICszODQsMTAgQEAgc3RhdGljIGlubGluZSB1NjQgX19ncGZuX2lz
X2lvKHU2NCBncGZuKQogI2RlZmluZSBNT0RFX0lORChwc3IpCVwKIAkoKChwc3IpLml0IDw8IDIp
ICsgKChwc3IpLmR0IDw8IDEpICsgKHBzcikucnQpCiAKKyNpZm5kZWYgQ09ORklHX1NNUAorI2Rl
ZmluZSBfdm1tX3Jhd19zcGluX2xvY2soeCkJIGRvIHt9d2hpbGUoMCkKKyNkZWZpbmUgX3ZtbV9y
YXdfc3Bpbl91bmxvY2soeCkgZG8ge313aGlsZSgwKQorI2Vsc2UKICNkZWZpbmUgX3ZtbV9yYXdf
c3Bpbl9sb2NrKHgpCQkJCQkJXAogCWRvIHsJCQkJCQkJCVwKIAkJX191MzIgKmlhNjRfc3Bpbmxv
Y2tfcHRyID0gKF9fdTMyICopICh4KTsJCVwKQEAgLTQwMyw2ICs0MDcsNyBAQCBzdGF0aWMgaW5s
aW5lIHU2NCBfX2dwZm5faXNfaW8odTY0IGdwZm4pCiAJZG8geyBiYXJyaWVyKCk7CQkJCVwKIAkJ
KChzcGlubG9ja190ICopeCktPnJhd19sb2NrLmxvY2sgPSAwOyB9IFwKIHdoaWxlICgwKQorI2Vu
ZGlmCiAKIHZvaWQgdm1tX3NwaW5fbG9jayhzcGlubG9ja190ICpsb2NrKTsKIHZvaWQgdm1tX3Nw
aW5fdW5sb2NrKHNwaW5sb2NrX3QgKmxvY2spOwotLSAKMS42LjAKCg==

--_002_706158FABBBA044BAD4FE898A02E4BC21983F9EBpdsmsx503ccrcor_--
