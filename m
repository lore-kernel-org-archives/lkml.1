Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbXEaP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbXEaP0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXEaP0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:26:14 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:56977 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbXEaP0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:26:13 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=uWexqsFno25ccz5MddMeboN8uC3/kCgBI5j8Ymo9wa74exP62KZR19dMpr7tFyNdUGONJ0afbwHPDDtGX17ReTTdRSIS4EKs1rrt7+Aq49zdWH3XfAaAFNDb9ODwDsKE;
X-IronPort-AV: E=Sophos;i="4.14,599,1170655200"; 
   d="scan'208";a="256871667"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7A398.043A15DA"
Subject: [linux-usb-devel] [PATCH] bug removing ehci-hcd
Date: Thu, 31 May 2007 10:26:10 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9524D64@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <20070529093324.92e571a0.akpm@linux-foundation.org>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-usb-devel] [PATCH] bug removing ehci-hcd
Thread-Index: AceiDxpfkLMZd7RCTzSMcJSC//x3gQAJpkBQ
References: <20070521024437.GA4751@inferi.kami.home><20070525214005.GA6925@suse.de><20070525150015.b5eaafc3.akpm@linux-foundation.org><DFEF91B22ED07447AB6AA4B237F913F9524D51@ausx3mpc125.aus.amer.dell.com> <20070529093324.92e571a0.akpm@linux-foundation.org>
From: <Stuart_Hayes@Dell.com>
To: <akpm@linux-foundation.org>
Cc: <gregkh@suse.de>, <malattia@linux.it>, <linux-kernel@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>,
       <linux-usb-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 31 May 2007 15:26:13.0118 (UTC) FILETIME=[05CF59E0:01C7A398]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7A398.043A15DA
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


I wasn't actually able to reproduce the bug myself, but I guess it is
pretty obvious that I shouldn't have called cpufreq_unregister_notifier
with a spinlock held.  I haven't been doing this long enough to know
exactly which kernel this patch should be against, so let me know if
this ins't good.  Thanks!


This patch (for the 2.6.21.3 kernel plus previously sent cpufreq
notifier patch) fixes a bug caused by calling
cpufreq_unregister_notifier (which can sleep) while holding a spinlock.

Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>

------_=_NextPart_001_01C7A398.043A15DA
Content-Type: application/octet-stream;
	name="ehci_unregister_cpufreq_notifier.patch"
Content-Transfer-Encoding: base64
Content-Description: ehci_unregister_cpufreq_notifier.patch
Content-Disposition: attachment;
	filename="ehci_unregister_cpufreq_notifier.patch"

ZGlmZiAtcHVyTiBsaW51eC0yLjYuMjEuM19mcmVxb3JpZy9kcml2ZXJzL3VzYi9ob3N0L2VoY2kt
aGNkLmMgbGludXgtMi42LjIxLjNfZnJlcWJ1Z2ZpeC9kcml2ZXJzL3VzYi9ob3N0L2VoY2ktaGNk
LmMKLS0tIGxpbnV4LTIuNi4yMS4zX2ZyZXFvcmlnL2RyaXZlcnMvdXNiL2hvc3QvZWhjaS1oY2Qu
YwkyMDA3LTA1LTI5IDE2OjA1OjIwLjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLjNf
ZnJlcWJ1Z2ZpeC9kcml2ZXJzL3VzYi9ob3N0L2VoY2ktaGNkLmMJMjAwNy0wNS0yOSAxNTo0MDo0
MS4wMDAwMDAwMDAgLTA1MDAKQEAgLTQ0OSwxNCArNDQ5LDE0IEBAIHN0YXRpYyB2b2lkIGVoY2lf
c3RvcCAoc3RydWN0IHVzYl9oY2QgKmgKIAkvKiBubyBtb3JlIGludGVycnVwdHMgLi4uICovCiAJ
ZGVsX3RpbWVyX3N5bmMgKCZlaGNpLT53YXRjaGRvZyk7CiAKLQlzcGluX2xvY2tfaXJxKCZlaGNp
LT5sb2NrKTsKLQlpZiAoSENfSVNfUlVOTklORyAoaGNkLT5zdGF0ZSkpCi0JCWVoY2lfcXVpZXNj
ZSAoZWhjaSk7Ci0KICNpZmRlZiBDT05GSUdfQ1BVX0ZSRVEKIAljcHVmcmVxX3VucmVnaXN0ZXJf
bm90aWZpZXIoJmVoY2ktPmNwdWZyZXFfdHJhbnNpdGlvbiwKIAkJCQkgICAgQ1BVRlJFUV9UUkFO
U0lUSU9OX05PVElGSUVSKTsKICNlbmRpZgorCXNwaW5fbG9ja19pcnEoJmVoY2ktPmxvY2spOwor
CWlmIChIQ19JU19SVU5OSU5HIChoY2QtPnN0YXRlKSkKKwkJZWhjaV9xdWllc2NlIChlaGNpKTsK
KwogCWVoY2lfcmVzZXQgKGVoY2kpOwogCWVoY2lfd3JpdGVsKGVoY2ksIDAsICZlaGNpLT5yZWdz
LT5pbnRyX2VuYWJsZSk7CiAJc3Bpbl91bmxvY2tfaXJxKCZlaGNpLT5sb2NrKTsK

------_=_NextPart_001_01C7A398.043A15DA--
