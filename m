Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbYHTQSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbYHTQSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbYHTQSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:18:30 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:31022 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYHTQS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=PZhOnVSGzm+wkWvmjzOsvO/d9ZMEljENdMAUZm0sp+sGPZo2gTnxsynfJmcxa4dOTq
         JNWkmXFT1mwEawNvMJjHfD2G6JoNDQJlfAKtqXzY3hgIV/AvBjTTGfMZQGtJHOQ6EB7p
         AuWF4Y/8Rno/UARyPwtO9bGWwbi32utBbJSBg=
Message-ID: <19f34abd0808200918n54aba154ta3c06dd7fbdf383f@mail.gmail.com>
Date: Wed, 20 Aug 2008 18:18:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "the arch/x86 maintainers" <x86@kernel.org>
Subject: Re: latest -git: BUG: unable to handle kernel paging request (numaq_tsc_disable)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808200912y3f9cd132hee6cd7ea9852d112@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_39421_4602885.1219249106908"
References: <19f34abd0808200828o6496cbeap75b7242845e96ef3@mail.gmail.com>
	 <19f34abd0808200840v17a8e5d4ge60c332f864abd81@mail.gmail.com>
	 <19f34abd0808200912y3f9cd132hee6cd7ea9852d112@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_39421_4602885.1219249106908
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Aug 20, 2008 at 6:12 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Wed, Aug 20, 2008 at 5:40 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> On Wed, Aug 20, 2008 at 5:28 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>> Hi,
>>>
>>> This actually hardlocked my machine and I had to add an extra patch to
>>> get any output at all. Base version is latest git, commit
>>> 1fca25427482387689fa27594c992a961d98768f.
>>>
>>
>> ...
>>
>>> Booting processor 1/1 ip 6000
>>> <1>BUG: unable to handle kernel paging request at c08a45f0
>>> <1>IP: [<c08a45f0>] numaq_tsc_disable+0x0/0x40
>>> <0> [<c0678676>] ? init_intel+0x196/0x360
>>
>> Seems to be a section mismatch; init_intel() is __cpuinit while
>> numaq_tsc_disable() is __init. Seems to be introduced in:
>>
>> commit 64898a8bad8c94ad7a4bd5cc86b66edfbb081f4a
>> Author: Yinghai Lu <yhlu.kernel@gmail.com>
>> Date:   Sat Jul 19 18:01:16 2008 -0700
>>
>>    x86: extend and use x86_quirks to clean up NUMAQ code
>
> Oops, I am wrong about numaq_tsc_disable() being __init. Still, I
> believe that Yinghai might be able to say what's really wrong :-)

Err... No, I am confusing myself! I had already applied a patch to
change it to __cpuinit :-/

The good news is that the bug is now fixed. Patch attached.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

------=_Part_39421_4602885.1219249106908
Content-Type: application/octet-stream;
 name=0001-x86-numaq-fix-section-mismatch.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk45e39i0
Content-Disposition: attachment;
 filename=0001-x86-numaq-fix-section-mismatch.patch

RnJvbSBkYzJkYTkzN2Q1ZmI4OTM0ZWRkOTVhNjIxODk1Mjk5YTYxODVlMWEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWZWdhcmQgTm9zc3VtIDx2ZWdhcmRub0BiZW4uaWZpLnVpby5u
bz4KRGF0ZTogV2VkLCAyMCBBdWcgMjAwOCAxODoxNToyMSArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IHg4Ni9udW1hcTogZml4IHNlY3Rpb24gbWlzbWF0Y2gKClRoaXMgc2VjdGlvbiBtaXNtYXRjaCB3
b3VsZCBsZWFkIHRvIHRoaXMgY3Jhc2g6CgpCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBh
Z2luZyByZXF1ZXN0IGF0IGMwOGE0NWYwCklQOiBbPGMwOGE0NWYwPl0gbnVtYXFfdHNjX2Rpc2Fi
bGUrMHgwLzB4NDAKCkNjOiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+ClNpZ25l
ZC1vZmYtYnk6IFZlZ2FyZCBOb3NzdW0gPHZlZ2FyZG5vQGlmaS51aW8ubm8+Ci0tLQogYXJjaC94
ODYva2VybmVsL251bWFxXzMyLmMgfCAgICAyICstCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvbnVt
YXFfMzIuYyBiL2FyY2gveDg2L2tlcm5lbC9udW1hcV8zMi5jCmluZGV4IGI4YzQ1NjEuLmVlY2M4
YzEgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9udW1hcV8zMi5jCisrKyBiL2FyY2gveDg2
L2tlcm5lbC9udW1hcV8zMi5jCkBAIC03Myw3ICs3Myw3IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBz
bXBfZHVtcF9xY3Qodm9pZCkKIH0KIAogCi12b2lkIF9faW5pdCBudW1hcV90c2NfZGlzYWJsZSh2
b2lkKQordm9pZCBfX2NwdWluaXQgbnVtYXFfdHNjX2Rpc2FibGUodm9pZCkKIHsKIAlpZiAoIWZv
dW5kX251bWFxKQogCQlyZXR1cm47Ci0tIAoxLjUuNi40Cgo=
------=_Part_39421_4602885.1219249106908--
