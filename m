Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbYCKGXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbYCKGXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbYCKGXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:23:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:50802 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113AbYCKGXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Bky3GRqtcwIX3BUxwFPtbMIzg7T0SIK+2nfGdvctKwhmRG5dFJLvjPuPwDpjus9IMJ8VGL4HAkdNhYTE8YPoeoyNpeEIDVBBR/7JdNAGiF2iMCyfdTd6IH7Mv4BXZ+gPNqhyEA1KpkZqPZWf2wQe29THxnbz2styWtEaxabamuI=
Message-ID: <86802c440803102323k62b6f908l72b3680f25f27650@mail.gmail.com>
Date: Mon, 10 Mar 2008 23:23:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH] mm: fix alloc_bootmem_core to use fast searching for all nodes
Cc: "kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_562_3004506.1205216622767"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_562_3004506.1205216622767
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH] mm: fix alloc_bootmem_core to use fast searching for all nodes

make the nodes other than node 0 could use bdata->last_success for
fast search too.

we need to use __alloc_bootmem_core for vmemmap allocation for other nodes when
numa and sparsemem/vmemmap are enabled.

also make fail_block path increase i with incr only needed after ALIGN to avoid
extra increase when size is large than align.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_562_3004506.1205216622767
Content-Type: text/x-patch; name=vmemmap_2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdo2rv670
Content-Disposition: attachment; filename=vmemmap_2.patch

CkluZGV4OiBsaW51eC0yLjYvbW0vYm9vdG1lbS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5v
cmlnL21tL2Jvb3RtZW0uYworKysgbGludXgtMi42L21tL2Jvb3RtZW0uYwpAQCAtMjI3LDI4ICsy
MjcsMzIgQEAgX19hbGxvY19ib290bWVtX2NvcmUoc3RydWN0IGJvb3RtZW1fZGF0YQogCSAqIFdl
IHRyeSB0byBhbGxvY2F0ZSBib290bWVtIHBhZ2VzIGFib3ZlICdnb2FsJwogCSAqIGZpcnN0LCB0
aGVuIHdlIHRyeSB0byBhbGxvY2F0ZSBsb3dlciBwYWdlcy4KIAkgKi8KLQlpZiAoZ29hbCAmJiBn
b2FsID49IGJkYXRhLT5ub2RlX2Jvb3Rfc3RhcnQgJiYgUEZOX0RPV04oZ29hbCkgPCBlbmRfcGZu
KSB7Ci0JCXByZWZlcnJlZCA9IGdvYWwgLSBiZGF0YS0+bm9kZV9ib290X3N0YXJ0OworCXByZWZl
cnJlZCA9IDA7CisJaWYgKGdvYWwgJiYgUEZOX0RPV04oZ29hbCkgPCBlbmRfcGZuKSB7CisJCWlm
IChnb2FsID4gYmRhdGEtPm5vZGVfYm9vdF9zdGFydCkKKwkJCXByZWZlcnJlZCA9IGdvYWwgLSBi
ZGF0YS0+bm9kZV9ib290X3N0YXJ0OwogCiAJCWlmIChiZGF0YS0+bGFzdF9zdWNjZXNzID49IHBy
ZWZlcnJlZCkKIAkJCWlmICghbGltaXQgfHwgKGxpbWl0ICYmIGxpbWl0ID4gYmRhdGEtPmxhc3Rf
c3VjY2VzcykpCiAJCQkJcHJlZmVycmVkID0gYmRhdGEtPmxhc3Rfc3VjY2VzczsKLQl9IGVsc2UK
LQkJcHJlZmVycmVkID0gMDsKKwl9CiAKIAlwcmVmZXJyZWQgPSBQRk5fRE9XTihBTElHTihwcmVm
ZXJyZWQsIGFsaWduKSkgKyBvZmZzZXQ7CiAJYXJlYXNpemUgPSAoc2l6ZSArIFBBR0VfU0laRS0x
KSAvIFBBR0VfU0laRTsKIAlpbmNyID0gYWxpZ24gPj4gUEFHRV9TSElGVCA/IDogMTsKIAogcmVz
dGFydF9zY2FuOgotCWZvciAoaSA9IHByZWZlcnJlZDsgaSA8IGVpZHg7IGkgKz0gaW5jcikgewor
CWZvciAoaSA9IHByZWZlcnJlZDsgaSA8IGVpZHg7KSB7CiAJCXVuc2lnbmVkIGxvbmcgajsKKwog
CQlpID0gZmluZF9uZXh0X3plcm9fYml0KGJkYXRhLT5ub2RlX2Jvb3RtZW1fbWFwLCBlaWR4LCBp
KTsKIAkJaSA9IEFMSUdOKGksIGluY3IpOwogCQlpZiAoaSA+PSBlaWR4KQogCQkJYnJlYWs7Ci0J
CWlmICh0ZXN0X2JpdChpLCBiZGF0YS0+bm9kZV9ib290bWVtX21hcCkpCisJCWlmICh0ZXN0X2Jp
dChpLCBiZGF0YS0+bm9kZV9ib290bWVtX21hcCkpIHsKKwkJCWkgKz0gaW5jcjsKIAkJCWNvbnRp
bnVlOworCQl9CiAJCWZvciAoaiA9IGkgKyAxOyBqIDwgaSArIGFyZWFzaXplOyArK2opIHsKIAkJ
CWlmIChqID49IGVpZHgpCiAJCQkJZ290byBmYWlsX2Jsb2NrOwpAQCAtMjU5LDYgKzI2Myw4IEBA
IHJlc3RhcnRfc2NhbjoKIAkJZ290byBmb3VuZDsKIAlmYWlsX2Jsb2NrOgogCQlpID0gQUxJR04o
aiwgaW5jcik7CisJCWlmIChpID09IGopCisJCQlpICs9IGluY3I7CiAJfQogCiAJaWYgKHByZWZl
cnJlZCA+IG9mZnNldCkgewo=
------=_Part_562_3004506.1205216622767--
