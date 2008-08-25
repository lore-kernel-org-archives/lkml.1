Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbYHYToU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbYHYToU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbYHYToM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:44:12 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48651 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYHYToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=coaq+6gRdmZQ2JhRce1vuSd6FGDrnmhRW6YCsvb829eM7H2fW+aZCL8z9rl3FhAW77
         BgjhKwM+i3im0NyYP/GCWcl/qbC89GbtvlKor6jYeg+F2Y6zZLS6sC9BDjfOHBj/GXAf
         SkoO40RsLkZZQ07Xb1darN6So84joJtreLRyQ=
Message-ID: <19f34abd0808251244v439e78b1hbb24f77c637559c3@mail.gmail.com>
Date: Mon, 25 Aug 2008 21:44:09 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: SLUB/debugobjects locking (Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_92374_6092228.1219693449156"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_92374_6092228.1219693449156
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Aug 25, 2008 at 3:03 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> Hi Linus, Vegard,
>
> On Sun, Aug 24, 2008 at 7:58 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Sun, 24 Aug 2008, Vegard Nossum wrote:
> [snip]
>> Anyway, I think your patch is likely fine, I just thought it looked a bit
>> odd to have a loop to move a list from one head pointer to another.
>>
>> But regardless, it would need some testing. Daniel?
>
> This opens another lockdep report at boot-time [1] - promoting
> pool_lock may not be the best fix?
>
> We then see a new deadlock condition (on the pool_lock spinlock) [2],
> which seemingly was avoided by taking the debug-bucket lock first.
>
> We reproduce this by booting with debug_objects=1 and causing a lot of activity.

Thanks. I get the same thing here as well.

I tried your suggestion of promoting the lock to irq-safe, and it
fixed the warning for me (didn't get or look for deadlocks yet, but it
seems likely that it is caused by the same thing?), the patch is
attached for reference.

I also don't know if this is the best fix, but I also don't have any
other (better) suggestions.

Others are welcome to pick it up from here...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

------=_Part_92374_6092228.1219693449156
Content-Type: application/octet-stream; name=promoted.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkbhvyqy0
Content-Disposition: attachment; filename=promoted.patch

ZGlmZiAtLWdpdCBhL2xpYi9kZWJ1Z29iamVjdHMuYyBiL2xpYi9kZWJ1Z29iamVjdHMuYwppbmRl
eCA5ZDgxNjFmLi5hYzQ2NDA1IDEwMDY0NAotLS0gYS9saWIvZGVidWdvYmplY3RzLmMKKysrIGIv
bGliL2RlYnVnb2JqZWN0cy5jCkBAIC0xMTYsOSArMTE2LDEwIEBAIHN0YXRpYyBzdHJ1Y3QgZGVi
dWdfb2JqICpsb29rdXBfb2JqZWN0KHZvaWQgKmFkZHIsIHN0cnVjdCBkZWJ1Z19idWNrZXQgKmIp
CiBzdGF0aWMgc3RydWN0IGRlYnVnX29iaiAqCiBhbGxvY19vYmplY3Qodm9pZCAqYWRkciwgc3Ry
dWN0IGRlYnVnX2J1Y2tldCAqYiwgc3RydWN0IGRlYnVnX29ial9kZXNjciAqZGVzY3IpCiB7CisJ
dW5zaWduZWQgbG9uZyBmbGFnczsKIAlzdHJ1Y3QgZGVidWdfb2JqICpvYmogPSBOVUxMOwogCi0J
c3Bpbl9sb2NrKCZwb29sX2xvY2spOworCXNwaW5fbG9ja19pcnFzYXZlKCZwb29sX2xvY2ssIGZs
YWdzKTsKIAlpZiAob2JqX3Bvb2wuZmlyc3QpIHsKIAkJb2JqCSAgICA9IGhsaXN0X2VudHJ5KG9i
al9wb29sLmZpcnN0LCB0eXBlb2YoKm9iaiksIG5vZGUpOwogCkBAIC0xMzcsNyArMTM4LDcgQEAg
YWxsb2Nfb2JqZWN0KHZvaWQgKmFkZHIsIHN0cnVjdCBkZWJ1Z19idWNrZXQgKmIsIHN0cnVjdCBk
ZWJ1Z19vYmpfZGVzY3IgKmRlc2NyKQogCQlpZiAob2JqX3Bvb2xfZnJlZSA8IG9ial9wb29sX21p
bl9mcmVlKQogCQkJb2JqX3Bvb2xfbWluX2ZyZWUgPSBvYmpfcG9vbF9mcmVlOwogCX0KLQlzcGlu
X3VubG9jaygmcG9vbF9sb2NrKTsKKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwb29sX2xvY2ss
IGZsYWdzKTsKIAogCXJldHVybiBvYmo7CiB9CkBAIC0xNDcsMTggKzE0OCwxOSBAQCBhbGxvY19v
YmplY3Qodm9pZCAqYWRkciwgc3RydWN0IGRlYnVnX2J1Y2tldCAqYiwgc3RydWN0IGRlYnVnX29i
al9kZXNjciAqZGVzY3IpCiAgKi8KIHN0YXRpYyB2b2lkIGZyZWVfb2JqZWN0KHN0cnVjdCBkZWJ1
Z19vYmogKm9iaikKIHsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOwogCXVuc2lnbmVkIGxvbmcgaWR4
ID0gKHVuc2lnbmVkIGxvbmcpKG9iaiAtIG9ial9zdGF0aWNfcG9vbCk7CiAKIAlpZiAob2JqX3Bv
b2xfZnJlZSA8IE9ERUJVR19QT09MX1NJWkUgfHwgaWR4IDwgT0RFQlVHX1BPT0xfU0laRSkgewot
CQlzcGluX2xvY2soJnBvb2xfbG9jayk7CisJCXNwaW5fbG9ja19pcnFzYXZlKCZwb29sX2xvY2ss
IGZsYWdzKTsKIAkJaGxpc3RfYWRkX2hlYWQoJm9iai0+bm9kZSwgJm9ial9wb29sKTsKIAkJb2Jq
X3Bvb2xfZnJlZSsrOwogCQlvYmpfcG9vbF91c2VkLS07Ci0JCXNwaW5fdW5sb2NrKCZwb29sX2xv
Y2spOworCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwb29sX2xvY2ssIGZsYWdzKTsKIAl9IGVs
c2UgewotCQlzcGluX2xvY2soJnBvb2xfbG9jayk7CisJCXNwaW5fbG9ja19pcnFzYXZlKCZwb29s
X2xvY2ssIGZsYWdzKTsKIAkJb2JqX3Bvb2xfdXNlZC0tOwotCQlzcGluX3VubG9jaygmcG9vbF9s
b2NrKTsKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcG9vbF9sb2NrLCBmbGFncyk7CiAJCWtt
ZW1fY2FjaGVfZnJlZShvYmpfY2FjaGUsIG9iaik7CiAJfQogfQo=
------=_Part_92374_6092228.1219693449156--
