Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389Ab0ARF3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab0ARF3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 00:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911Ab0ARF3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 00:29:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:46227 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab0ARF3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 00:29:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,294,1262592000"; 
   d="scan'208";a="484744733"
From: "Wu, Fengguang" <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       David Howells <dhowells@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Date: Mon, 18 Jan 2010 13:26:44 +0800
Subject: RE: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing
 negative f_pos
Thread-Topic: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing
 negative f_pos
Thread-Index: AcqX7eqS5Wt8efcwTi6LW59wOfZ+4wAEOfh3
Message-ID: <6CADD16F56BC954D8E28F3836FA7ED7112A9CD50FA@shzsmsx501.ccr.corp.intel.com>
References: <20100115013954.311049665@intel.com>
	<20100115014422.959401729@intel.com>	<87bpgurz00.fsf@devron.myhome.or.jp>
	<20100118091527.7a0e2c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<87y6jwnrcz.fsf@devron.myhome.or.jp>
	<20100118102544.3e897525.kamezawa.hiroyu@jp.fujitsu.com>
	<87pr58kx9o.fsf@devron.myhome.or.jp>
	<20100118110019.c55ad88a.kamezawa.hiroyu@jp.fujitsu.com>
	<87y6jwjh3j.fsf@devron.myhome.or.jp>
	<20100118113026.4c6efd26.kamezawa.hiroyu@jp.fujitsu.com>
	<6CADD16F56BC954D8E28F3836FA7ED7112A9CD50F6@shzsmsx501.ccr.corp.intel.com>,<20100118122214.1d13a3e4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100118122214.1d13a3e4.kamezawa.hiroyu@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_6CADD16F56BC954D8E28F3836FA7ED7112A9CD50FAshzsmsx501ccr_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_6CADD16F56BC954D8E28F3836FA7ED7112A9CD50FAshzsmsx501ccr_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


> On error, the kernel returns -EOVERFLOW (via %eax) and libc hides
> it by
>  errno =3D EOVERFLOW
>  ret =3D -1

Ah got it. How about the attached patch?

Thanks,
Fengguang

--_002_6CADD16F56BC954D8E28F3836FA7ED7112A9CD50FAshzsmsx501ccr_
Content-Type: application/octet-stream; name="mem-seek-fix"
Content-Description: mem-seek-fix
Content-Disposition: attachment; filename="mem-seek-fix"; size=1404;
	creation-date="Mon, 18 Jan 2010 13:27:40 GMT";
	modification-date="Mon, 18 Jan 2010 13:27:40 GMT"
Content-Transfer-Encoding: base64

ZGV2bWVtOiBkb24ndCBhbGxvdyBzZWVrIHRvIGxhc3QgcGFnZQoKU28gYXMgdG8gcmV0dXJuIGEg
dW5pZm9ybSBlcnJvciAtRU9WRVJGTE9XIGluc3RlYWQgb2YgYSByYW5kb20gb25lOgoKIyBrbWVt
LXNlZWsgMHhmZmZmZmZmZmZmZmZmZmYwCnNlZWsgL2Rldi9rbWVtOiBEZXZpY2Ugb3IgcmVzb3Vy
Y2UgYnVzeQojIGttZW0tc2VlayAweGZmZmZmZmZmZmZmZmZmZjEKc2VlayAvZGV2L2ttZW06IEJs
b2NrIGRldmljZSByZXF1aXJlZAoKU3VnZ2VzdGVkIGJ5IE9HQVdBIEhpcm9mdW1pLgoKQ0M6IE9H
QVdBIEhpcm9mdW1pIDxoaXJvZnVtaUBtYWlsLnBhcmtuZXQuY28uanA+CkNDOiBLQU1FWkFXQSBI
aXJveXVraSA8a2FtZXphd2EuaGlyb3l1QGpwLmZ1aml0c3UuY29tPiAKU2lnbmVkLW9mZi1ieTog
V3UgRmVuZ2d1YW5nIDxmZW5nZ3Vhbmcud3VAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMvY2hhci9t
ZW0uYyB8ICAgMTkgKysrKysrKysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEzIGluc2Vy
dGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgotLS0gbGludXgtbW0ub3JpZy9kcml2ZXJzL2NoYXIv
bWVtLmMJMjAxMC0wMS0xOCAxMjozNzoxMS4wMDAwMDAwMDAgKzA4MDAKKysrIGxpbnV4LW1tL2Ry
aXZlcnMvY2hhci9tZW0uYwkyMDEwLTAxLTE4IDEzOjE4OjI0LjAwMDAwMDAwMCArMDgwMApAQCAt
NzI1LDE2ICs3MjUsMjMgQEAgc3RhdGljIGxvZmZfdCBtZW1vcnlfbHNlZWsoc3RydWN0IGZpbGUg
KgogCiAJbXV0ZXhfbG9jaygmZmlsZS0+Zl9wYXRoLmRlbnRyeS0+ZF9pbm9kZS0+aV9tdXRleCk7
CiAJc3dpdGNoIChvcmlnKSB7Ci0JCWNhc2UgMDoKKwkJY2FzZSBTRUVLX0NVUjoKKwkJCW9mZnNl
dCArPSBmaWxlLT5mX3BvczsKKwkJCWlmICgodW5zaWduZWQgbG9uZyBsb25nKW9mZnNldCA8CisJ
CQkgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylmaWxlLT5mX3BvcykgeworCQkJCXJldCA9IC1FT1ZF
UkZMT1c7CisJCQkJYnJlYWs7CisJCQl9CisJCWNhc2UgU0VFS19TRVQ6CisJCQkvKiB0byBhdm9p
ZCBlZy4gbWlzdGFraW5nIGZfcG9zPS05IGFzIC1FQkFERj0tOSAqLworCQkJaWYgKCh1bnNpZ25l
ZCBsb25nIGxvbmcpb2Zmc2V0ID49IH4weEZGRlVMTCkgeworCQkJCXJldCA9IC1FT1ZFUkZMT1c7
CisJCQkJYnJlYWs7CisJCQl9CiAJCQlmaWxlLT5mX3BvcyA9IG9mZnNldDsKIAkJCXJldCA9IGZp
bGUtPmZfcG9zOwogCQkJZm9yY2Vfc3VjY2Vzc2Z1bF9zeXNjYWxsX3JldHVybigpOwogCQkJYnJl
YWs7Ci0JCWNhc2UgMToKLQkJCWZpbGUtPmZfcG9zICs9IG9mZnNldDsKLQkJCXJldCA9IGZpbGUt
PmZfcG9zOwotCQkJZm9yY2Vfc3VjY2Vzc2Z1bF9zeXNjYWxsX3JldHVybigpOwotCQkJYnJlYWs7
CiAJCWRlZmF1bHQ6CiAJCQlyZXQgPSAtRUlOVkFMOwogCX0K

--_002_6CADD16F56BC954D8E28F3836FA7ED7112A9CD50FAshzsmsx501ccr_--
