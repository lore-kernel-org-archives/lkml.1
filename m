Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYHYElh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYHYElh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 00:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYHYEl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 00:41:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:14452 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYHYEl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 00:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=GXYQImBwxzvpOJ42CXErOpe6egOKB1cjLPc4XhNpxuA6MmtmDuIqTxhhYMg9og4rac
         Tf8EdrZOQzynbVoiLZqiZhG0hSbf4wrxZDk/BAJZGsScFkur1TEfl/CvCa35TRBNsjaQ
         /igYa+fSj4Yczcc9+cnGPBoy0E2SLfaTpQJ+s=
Message-ID: <86802c440808242141j716b5875s709dc56c1163a7d5@mail.gmail.com>
Date: Sun, 24 Aug 2008 21:41:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <914225.91320.qm@web82104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_41730_6380725.1219639288110"
References: <914225.91320.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_41730_6380725.1219639288110
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Aug 24, 2008 at 7:00 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> after discussing with Ingo, we have one more generic way to detect the
>> same situation.
>>
>> please help to verify the attached patch. ( don't apply previous patch)
>
> Geez, a guy tries to leave so he doesn't get banned because of his stupid
> webmail client, and...  oh, never mind...  ;)
>
>
> Results:
>
> 1) patch applied perfectly to tip/master.
>
> 2) patched file compiles without warning or error.
> (I thought there would be a type mismatch -- the "base" variable in your
> patch is unsigned long, while "res->start" is resource_size_t ==>
> u64 ==> unsigned long long, but I must have been mistaken.)
>
> 3) kernel builds fine
>
> 4) reboot hangs at the familiar call of inet_init()
>

this one should work. please apply this one only.

YH

------=_Part_41730_6380725.1219639288110
Content-Type: text/x-patch; name=check_res_with_bar_v2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkaloxoc0
Content-Disposition: attachment; filename=check_res_with_bar_v2.patch

W1BBVENIXSB4ODY6IGNoZWNrIGhwZXQgd2l0aCBCQVIgdjIKCmluc2VydCBzb21lIHJlc291cmNl
cyB0byByZXNvdXJjZSB0cmVlIGZvcmNpbHksIHNvIGNvdWxkIGF2b2lkIGtlcm5lbCB1cGRhdGUg
dGhlCnJlc291cmNlcyBpbiBwY2kgZGV2aWNlLgoKc2hvdWxkIGNoZWNrIGluIGRldmljZSB0b28u
CgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+CgotLS0K
IGFyY2gveDg2L3BjaS9pMzg2LmMgfCAgIDQzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA0MyBpbnNlcnRpb25zKCspCgpJbmRleDog
bGludXgtMi42L2FyY2gveDg2L3BjaS9pMzg2LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9y
aWcvYXJjaC94ODYvcGNpL2kzODYuYworKysgbGludXgtMi42L2FyY2gveDg2L3BjaS9pMzg2LmMK
QEAgLTMzLDYgKzMzLDcgQEAKICNpbmNsdWRlIDxsaW51eC9ib290bWVtLmg+CiAKICNpbmNsdWRl
IDxhc20vcGF0Lmg+CisjaW5jbHVkZSA8YXNtL2hwZXQuaD4KIAogI2luY2x1ZGUgInBjaS5oIgog
CkBAIC03Nyw2ICs3OCwzMCBAQCBwY2liaW9zX2FsaWduX3Jlc291cmNlKHZvaWQgKmRhdGEsIHN0
cnVjCiB9CiBFWFBPUlRfU1lNQk9MKHBjaWJpb3NfYWxpZ25fcmVzb3VyY2UpOwogCitzdGF0aWMg
aW50IGNoZWNrX3Jlc193aXRoX3ZhbGlkKHN0cnVjdCBwY2lfZGV2ICpkZXYsIHN0cnVjdCByZXNv
dXJjZSAqcmVzKQoreworCXVuc2lnbmVkIGxvbmcgYmFzZTsKKwl1bnNpZ25lZCBsb25nIHNpemU7
CisKKwliYXNlID0gcmVzLT5zdGFydDsKKwlzaXplID0gKHJlcy0+c3RhcnQgPT0gMCAmJiByZXMt
PmVuZCA9PSByZXMtPnN0YXJ0KSA/IDAgOgorCQkgKHJlcy0+ZW5kIC0gcmVzLT5zdGFydCArIDEp
OworCisJaWYgKCFiYXNlIHx8ICFzaXplKQorCQlyZXR1cm4gMDsKKworI2lmZGVmIENPTkZJR19I
UEVUX1RJTUVSCisJLyogZm9yIGhwZXQgKi8KKwlpZiAoYmFzZSA9PSBocGV0X2FkZHJlc3MgJiYg
KHJlcy0+ZmxhZ3MgJiBJT1JFU09VUkNFX01FTSkpIHsKKwkJZGV2X2luZm8oJmRldi0+ZGV2LCAi
QkFSIGhhcyBIUEVUIGF0ICUwOGx4LSUwOGx4XG4iLAorCQkJCSBiYXNlLCBiYXNlICsgc2l6ZSAt
IDEpOworCQlyZXR1cm4gMTsKKwl9CisjZW5kaWYKKworCXJldHVybiAwOworfQorCiAvKgogICog
IEhhbmRsZSByZXNvdXJjZXMgb2YgUENJIGRldmljZXMuICBJZiB0aGUgd29ybGQgd2VyZSBwZXJm
ZWN0LCB3ZSBjb3VsZAogICogIGp1c3QgYWxsb2NhdGUgYWxsIHRoZSByZXNvdXJjZSByZWdpb25z
IGFuZCBkbyBub3RoaW5nIG1vcmUuICBJdCBpc24ndC4KQEAgLTE3MSw2ICsxOTYsMjIgQEAgc3Rh
dGljIHZvaWQgX19pbml0IHBjaWJpb3NfYWxsb2NhdGVfcmVzbwogCQkJCQlyLT5mbGFncywgZGlz
YWJsZWQsIHBhc3MpOwogCQkJCXByID0gcGNpX2ZpbmRfcGFyZW50X3Jlc291cmNlKGRldiwgcik7
CiAJCQkJaWYgKCFwciB8fCByZXF1ZXN0X3Jlc291cmNlKHByLCByKSA8IDApIHsKKwkJCQkJaWYg
KGNoZWNrX3Jlc193aXRoX3ZhbGlkKGRldiwgcikpIHsKKwkJCQkJCXN0cnVjdCByZXNvdXJjZSAq
cm9vdCA9IE5VTEw7CisKKwkJCQkJCS8qCisJCQkJCQkgKiBmb3JjaWJseSBpbnNlcnQgaXQgaW50
byB0aGUKKwkJCQkJCSAqIHJlc291cmNlIHRyZWUKKwkJCQkJCSAqLworCQkJCQkJaWYgKHItPmZs
YWdzICYgSU9SRVNPVVJDRV9NRU0pCisJCQkJCQkJcm9vdCA9ICZpb21lbV9yZXNvdXJjZTsKKwkJ
CQkJCWVsc2UgaWYgKHItPmZsYWdzICYgSU9SRVNPVVJDRV9JTykKKwkJCQkJCQlyb290ID0gJmlv
cG9ydF9yZXNvdXJjZTsKKworCQkJCQkJaWYgKHJvb3QpCisJCQkJCQkJaW5zZXJ0X3Jlc291cmNl
KHJvb3QsIHIpOworCQkJCQkJY29udGludWU7CisJCQkJCX0KIAkJCQkJZGV2X2VycigmZGV2LT5k
ZXYsICJCQVIgJWQ6IGNhbid0ICIKIAkJCQkJCSJhbGxvY2F0ZSByZXNvdXJjZVxuIiwgaWR4KTsK
IAkJCQkJLyogV2UnbGwgYXNzaWduIGEgbmV3IGFkZHJlc3MgbGF0ZXIgKi8K
------=_Part_41730_6380725.1219639288110--
