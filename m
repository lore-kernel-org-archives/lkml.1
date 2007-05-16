Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbXEPTIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbXEPTIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbXEPTH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:07:56 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbXEPTH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:07:56 -0400
Message-ID: <464B565F.3060900@zytor.com>
Date: Wed, 16 May 2007 12:07:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: boot failure under qemu
References: <464ABF7C.1000307@goop.org> <464B2762.7040508@zytor.com> <464B318F.1060309@goop.org> <464B4687.20901@zytor.com> <464B4C68.6080804@goop.org>
In-Reply-To: <464B4C68.6080804@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------040102030108030307040106"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040102030108030307040106
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Okay, I've established that this is a bug in the Qemu kernel loader: the
>> Qemu loader puts zero in the loadflags, which is wrong no matter how you
>> slice it.
>>
>> I have checked in a workaround in the git.newsetup tree; the workaround
>> is to rely on a compile-time value for load low/load high instead of
>> looking at loadflags.
>>   
> 
> Can you post a patch to try?
> 

Cumulative diff from -rc1-mm1.

	-hpa

--------------040102030108030307040106
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gvaTM4Ni9ib290L01ha2VmaWxlIGIvYXJjaC9pMzg2L2Jvb3Qv
TWFrZWZpbGUKaW5kZXggNjc5MmQwOS4uYTJiM2Y5MyAxMDA2NDQKLS0tIGEvYXJjaC9pMzg2
L2Jvb3QvTWFrZWZpbGUKKysrIGIvYXJjaC9pMzg2L2Jvb3QvTWFrZWZpbGUKQEAgLTYyLDYg
KzYyLDcgQEAgQUZMQUdTCQk6PSAkKENGTEFHUykgLURfX0FTU0VNQkxZX18KICQob2JqKS96
SW1hZ2U6ICBJTUFHRV9PRkZTRVQgOj0gMHgxMDAwCiAkKG9iaikvekltYWdlOiAgRVhUUkFf
QUZMQUdTIDo9ICQoU1ZHQV9NT0RFKSAkKFJBTURJU0spCiAkKG9iaikvYnpJbWFnZTogSU1B
R0VfT0ZGU0VUIDo9IDB4MTAwMDAwCiskKG9iaikvYnpJbWFnZTogRVhUUkFfQ0ZMQUdTIDo9
IC1EX19CSUdfS0VSTkVMX18KICQob2JqKS9iekltYWdlOiBFWFRSQV9BRkxBR1MgOj0gJChT
VkdBX01PREUpICQoUkFNRElTSykgLURfX0JJR19LRVJORUxfXwogJChvYmopL2J6SW1hZ2U6
IEJVSUxERkxBR1MgICA6PSAtYgogCmRpZmYgLS1naXQgYS9hcmNoL2kzODYvYm9vdC9tYWlu
LmMgYi9hcmNoL2kzODYvYm9vdC9tYWluLmMKaW5kZXggNWY0ZDk5ZC4uODczYzc3NyAxMDA2
NDQKLS0tIGEvYXJjaC9pMzg2L2Jvb3QvbWFpbi5jCisrKyBiL2FyY2gvaTM4Ni9ib290L21h
aW4uYwpAQCAtMTEyLDYgKzExMiwxMCBAQCB2b2lkIG1haW4odm9pZCkKIAlpZiAoYm9vdF9w
YXJhbXMuaGRyLmxvYWRmbGFncyAmIENBTl9VU0VfSEVBUCkgewogCQloZWFwX2VuZCA9IChj
aGFyICopKGJvb3RfcGFyYW1zLmhkci5oZWFwX2VuZF9wdHIKIAkJCQkgICAgKzB4MjAwLVNU
QUNLX1NJWkUpOworCX0gZWxzZSB7CisJCS8qIEJvb3QgcHJvdG9jb2wgMi4wMCBvbmx5LCBu
byBoZWFwIGF2YWlsYWJsZSAqLworCQlwdXRzKCJXQVJOSU5HOiBBbmNpZW50IGJvb3Rsb2Fk
ZXIsIHNvbWUgZnVuY3Rpb25hbGl0eSAiCisJCSAgICAgIm1heSBiZSBsaW1pdGVkIVxuIik7
CiAJfQogCiAJLyogTWFrZSBzdXJlIHdlIGhhdmUgYWxsIHRoZSBwcm9wZXIgQ1BVIHN1cHBv
cnQgKi8KZGlmZiAtLWdpdCBhL2FyY2gvaTM4Ni9ib290L21lbW9yeS5jIGIvYXJjaC9pMzg2
L2Jvb3QvbWVtb3J5LmMKaW5kZXggOGE4MmFhOS4uZDdiMjUwYiAxMDA2NDQKLS0tIGEvYXJj
aC9pMzg2L2Jvb3QvbWVtb3J5LmMKKysrIGIvYXJjaC9pMzg2L2Jvb3QvbWVtb3J5LmMKQEAg
LTMwLDcgKzMwLDcgQEAgc3RhdGljIGludCBkZXRlY3RfbWVtb3J5X2U4MjAodm9pZCkKIAkJ
c2l6ZSA9IHNpemVvZihzdHJ1Y3QgZTgyMGVudHJ5KTsKIAkJaWQgPSBTTUFQOwogCQlhc20o
ImludCAkMHgxNTsgc2V0YyAlMCIKLQkJICAgIDogIj1kbSIgKGVyciksICIrYiIgKG5leHQp
LCAiK2QiIChpZCksICIrYyIgKHNpemUpLAorCQkgICAgOiAiPWFtIiAoZXJyKSwgIitiIiAo
bmV4dCksICIrZCIgKGlkKSwgIitjIiAoc2l6ZSksCiAJCSAgICAgICI9bSIgKCpkZXNjKQog
CQkgICAgOiAiRCIgKGRlc2MpLCAiYSIgKDB4ZTgyMCkpOwogCmRpZmYgLS1naXQgYS9hcmNo
L2kzODYvYm9vdC9wbS5jIGIvYXJjaC9pMzg2L2Jvb3QvcG0uYwppbmRleCAxYzU4NmYxLi43
YWY2NWY5IDEwMDY0NAotLS0gYS9hcmNoL2kzODYvYm9vdC9wbS5jCisrKyBiL2FyY2gvaTM4
Ni9ib290L3BtLmMKQEAgLTQxLDEyICs0MSwxMyBAQCBzdGF0aWMgdm9pZCByZWFsbW9kZV9z
d2l0Y2hfaG9vayh2b2lkKQogICovCiBzdGF0aWMgdm9pZCBtb3ZlX2tlcm5lbF9hcm91bmQo
dm9pZCkKIHsKKwkvKiBOb3RlOiByZWx5IG9uIHRoZSBjb21waWxlLXRpbWUgb3B0aW9uIGhl
cmUgcmF0aGVyIHRoYW4KKwkgICB0aGUgTE9BREVEX0hJR0ggZmxhZy4gIFRoZSBRZW11IGtl
cm5lbCBsb2FkZXIgdW5jb25kaXRpb25hbGx5CisJICAgc2V0cyB0aGUgbG9hZGZsYWdzIHRv
IHplcm8uICovCisjaWZuZGVmIF9fQklHX0tFUk5FTF9fCiAJdTE2IGRzdF9zZWcsIHNyY19z
ZWc7CiAJdTMyIHN5c3NpemU7CiAKLQlpZiAoYm9vdF9wYXJhbXMuaGRyLmxvYWRmbGFncyAm
IExPQURFRF9ISUdIKQotCQlyZXR1cm47Ci0KIAlkc3Rfc2VnID0gIDB4MTAwMCA+PiA0Owog
CXNyY19zZWcgPSAweDEwMDAwID4+IDQ7CiAJc3lzc2l6ZSA9IGJvb3RfcGFyYW1zLmhkci5z
eXNzaXplOyAvKiBTaXplIGluIDE2LWJ5dGUgcGFyYWdyYXBzICovCkBAIC03Miw2ICs3Myw3
IEBAIHN0YXRpYyB2b2lkIG1vdmVfa2VybmVsX2Fyb3VuZCh2b2lkKQogCQlkc3Rfc2VnICs9
IHBhcmFzOwogCQlzcmNfc2VnICs9IHBhcmFzOwogCX0KKyNlbmRpZgogfQogCiAvKgo=
--------------040102030108030307040106--
