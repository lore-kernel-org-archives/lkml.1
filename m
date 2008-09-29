Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYI2IK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYI2IK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYI2IKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:10:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:11184 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYI2IKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Mwphh65Q4bPw2WrvubN/sSTVI8WCAAr/C35e9K2hRO16mrXzsm5kcYPoCpOuI2jVzr
         KONe3w1tuc3B5ldJG2wNd9JpMW6b4n3fST301KqIqTcB8uwsXcRVcdPl1wwFQZ+XsXlK
         9pWHtbUJYIQTozVKELn4TagWNok8xqY5Xztvk=
Message-ID: <520f0cf10809290110m6574d983h3b581443b2256cf5@mail.gmail.com>
Date: Mon, 29 Sep 2008 10:10:10 +0200
From: "John Kacur" <jkacur@gmail.com>
To: RT <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH]Real-time kernel compile-fix for 32-bit when disabling CONFIG_PREEMPT_RT
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Leon Woestenberg" <leon.woestenberg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_60682_2937650.1222675810848"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_60682_2937650.1222675810848
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

If you start with the real-time kernel linux-2.6.26.5-rt9 and
configure it to disable CONFIG_PREEMPT_RT, for example
CONFIG_PREEMPT_DESKTOP=y
# CONFIG_PREEMPT_RT is not set

you will get the following compile error on 32-bit i386. (actually,
this will happen on any platform that doesn't use
CONFIG_RWSEM_GENERIC_SPINLOCK)

In file included from include/linux/notifier.h:14,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:560,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:12,
                 from include/linux/percpu.h:5,
                 from include/linux/rcupdate.h:39,
                 from include/linux/tracepoint.h:18,
                 from include/linux/module.h:19,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_32.c:7,
                 from arch/x86/kernel/asm-offsets.c:2:
include/linux/rwsem.h:149: error: redefinition of 'rwsem_is_locked'
include/asm/rwsem.h:261: error: previous definition of
'rwsem_is_locked' was here
include/linux/rwsem.h: In function 'rwsem_is_locked':
include/linux/rwsem.h:151: error: implicit declaration of function
'compat_rwsem_is_locked'
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

The fix is simple, and should be folded back into the rt-mutex-core.patch
Fix is attached.

------=_Part_60682_2937650.1222675810848
Content-Type: application/octet-stream; name=rwsem_is_locked-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flos9k500
Content-Disposition: attachment; filename=rwsem_is_locked-fix.patch

U2lnbmVkLW9mZi1ieTogSm9obiBLYWN1ciA8amthY3VyQGdtYWlsLmNvbT4KClRoaXMgcGF0Y2gg
Zml4ZXMgYSBjb21waWxlIGVycm9yIGZvciBwbGF0Zm9ybXMgdGhhdCBhcmUgbm90IHVzaW5nCkNP
TkZJR19SV1NFTV9HRU5FUklDX1NQSU5MT0NLCnRoYXQgb2NjdXJzIHdoZW4geW91IGRvbid0IGNv
bmZpZ3VyZSBDT05GSUdfUFJFRU1QVF9SVAoKSXQgc2hvdWxkIGJlIGZvbGRlZCBpbnRvIHRoZSBy
dC1tdXRleC1jb3JlLnBhdGNoCgpJbmRleDogbGludXgtMi42LjI2LjUtcnQ5L2luY2x1ZGUvbGlu
dXgvcndzZW0uaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjYuNS1ydDkub3JpZy9pbmNsdWRl
L2xpbnV4L3J3c2VtLmgKKysrIGxpbnV4LTIuNi4yNi41LXJ0OS9pbmNsdWRlL2xpbnV4L3J3c2Vt
LmgKQEAgLTE0NiwxMCArMTQ2LDE0IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBkb3duZ3JhZGVfd3Jp
dGUoc3RydWMKIHsKIAljb21wYXRfZG93bmdyYWRlX3dyaXRlKHJ3c2VtKTsKIH0KKworI2lmZGVm
IENPTkZJR19SV1NFTV9HRU5FUklDX1NQSU5MT0NLCiBzdGF0aWMgaW5saW5lIGludCByd3NlbV9p
c19sb2NrZWQoc3RydWN0IGNvbXBhdF9yd19zZW1hcGhvcmUgKnNlbSkKIHsKIAlyZXR1cm4gY29t
cGF0X3J3c2VtX2lzX2xvY2tlZChzZW0pOwogfQorI2VuZGlmCisKICMgZGVmaW5lIGRvd25fcmVh
ZF9uZXN0ZWQoc2VtLCBzdWJjbGFzcykgXAogCQljb21wYXRfZG93bl9yZWFkX25lc3RlZChzZW0s
IHN1YmNsYXNzKQogIyBkZWZpbmUgZG93bl93cml0ZV9uZXN0ZWQoc2VtLCBzdWJjbGFzcykgXAo=

------=_Part_60682_2937650.1222675810848--
