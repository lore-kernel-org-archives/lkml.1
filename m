Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYF1Kau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYF1Kau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 06:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYF1Kal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 06:30:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:47427 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYF1Kak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 06:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=HpGPa6Z8DrjFAsVWZkR9n8Xx8OrZGaprmNv1pPTqTTM4/QlYfUwYXwOyQDzN1Kvh2G
         5qJaHJeDk+eaH2V2gWtij6vv5VVT1s26MHbNa60+wfj7RmIecRwa4EZXL6PgBOAIdHE3
         8++B5pRIo9Z2RWV4y60MMSuhLl2mhR9mvEVtI=
Message-ID: <86802c440806280330s6c8b1cb6o977290b535dc2343@mail.gmail.com>
Date: Sat, 28 Jun 2008 03:30:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080628074753.GA1856@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_11060_24307440.1214649039657"
References: <200806251748.06743.yhlu.kernel@gmail.com>
	 <200806252151.29028.yhlu.kernel@gmail.com>
	 <200806271538.46829.yhlu.kernel@gmail.com>
	 <200806272247.11971.yhlu.kernel@gmail.com>
	 <20080628063500.GA15710@elte.hu> <20080628070243.GA31342@elte.hu>
	 <86802c440806280022l76ef93c4kd18c578cdaba421a@mail.gmail.com>
	 <20080628074753.GA1856@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_11060_24307440.1214649039657
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Jun 28, 2008 at 12:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> On Sat, Jun 28, 2008 at 12:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >>
>> >> > some end boundary is only page alignment, instead of 2M alignment, so
>> >> > call ker_phycial_mapping_init three times. then don't overmap above
>> >> > the max_low_pfn
>> >>
>> >> applied to tip/x86/unify-setup, thanks Yinghai.
>> >
>> > -tip testing found a 32-bit spontaneous reboot during bootup, with this
>> > config:
>> >
>> >  http://redhat.com/~mingo/misc/config-Sat_Jun_28_08_43_52_CEST_2008.bad
>> >
>> > no serial log produced at all.
>> even with console=uart8250,io,0x03f8,115200n8 ?
>
> correct, i use earlyprintk=serial,ttyS0,115200.
>
> i just re-tested it - doing "git merge tip/x86/unify-setup" in the
> tip/master branch triggers the failure with that config on a wide range
> of 32-bit boxes.

please check attached v3..., that is less intrusive.

YH

------=_Part_11060_24307440.1214649039657
Content-Type: text/x-patch; name=fix_over_mapped.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fi02p4ip0
Content-Disposition: attachment; filename=fix_over_mapped.patch

W1BBVENIXSB4ODY6IGZpeCBpbml0X21lbW9yeV9tYXBwaW5nIG92ZXIgYm91bmRhcnkgdjMKCnNv
bWUgZW5kIGJvdW5kYXJ5IGlzIG9ubHkgcGFnZSBhbGlnbm1lbnQsIGluc3RlYWQgb2YgMk0gYWxp
Z25tZW50LAoKdjI6IG1ha2UgaW5pdF9tZW1vcnlfbWFwcGluZyBtb3JlIHNvbGlkOiBzdGFydCBj
b3VsZCBiZSBhbnkgdmFsdWUgb3RoZXIgdGhhbiAwCnYzOiBmaXggTk9OIFBBRSBieSBoYW5kbGlu
ZyBsZWZ0IG92ZXIgaW4ga2VybmVsX3BoeXNpY2FsX21hcHBpbmcKClNpZ25lZC1vZmYtYnk6IFlp
bmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCi0tLQogYXJjaC94ODYvbW0vaW5pdF8z
Mi5jIHwgICAyNCArKysrKysrKysrKysrKy0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNCBp
bnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYv
bW0vaW5pdF8zMi5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L21tL2lu
aXRfMzIuYworKysgbGludXgtMi42L2FyY2gveDg2L21tL2luaXRfMzIuYwpAQCAtMTk1LDcgKzE5
NSw3IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBrZXJuZWxfcGh5c2ljYWxfbWFwcGkKIAl1bnNpZ25l
ZCBwYWdlc18ybSA9IDAsIHBhZ2VzXzRrID0gMDsKIAl1bnNpZ25lZCBsaW1pdF9wZm4gPSBlbmQg
Pj4gUEFHRV9TSElGVDsKIAotCXBnZF9pZHggPSBwZ2RfaW5kZXgoUEFHRV9PRkZTRVQpOworCXBn
ZF9pZHggPSBwZ2RfaW5kZXgoc3RhcnQgKyBQQUdFX09GRlNFVCk7CiAJcGdkID0gcGdkX2Jhc2Ug
KyBwZ2RfaWR4OwogCXBmbiA9IHN0YXJ0ID4+IFBBR0VfU0hJRlQ7CiAKQEAgLTIxOCw3ICsyMTgs
OCBAQCBzdGF0aWMgdm9pZCBfX2luaXQga2VybmVsX3BoeXNpY2FsX21hcHBpCiAJCQkgKiBhbmQg
b3ZlcmxhcHBpbmcgTVRSUnMgaW50byBsYXJnZSBwYWdlcyBjYW4gY2F1c2UKIAkJCSAqIHNsb3dk
b3ducy4KIAkJCSAqLwotCQkJaWYgKGNwdV9oYXNfcHNlICYmICEocGdkX2lkeCA9PSAwICYmIHBt
ZF9pZHggPT0gMCkpIHsKKwkJCWlmIChjcHVfaGFzX3BzZSAmJiAhKHBnZF9pZHggPT0gMCAmJiBw
bWRfaWR4ID09IDApICYmCisJCQkJKHBmbiArIFBUUlNfUEVSX1BURSkgPD0gbGltaXRfcGZuKSB7
CiAJCQkJdW5zaWduZWQgaW50IGFkZHIyOwogCQkJCXBncHJvdF90IHByb3QgPSBQQUdFX0tFUk5F
TF9MQVJHRTsKIApAQCAtMjMzLDEzICsyMzQsMTIgQEAgc3RhdGljIHZvaWQgX19pbml0IGtlcm5l
bF9waHlzaWNhbF9tYXBwaQogCQkJCXNldF9wbWQocG1kLCBwZm5fcG1kKHBmbiwgcHJvdCkpOwog
CiAJCQkJcGZuICs9IFBUUlNfUEVSX1BURTsKLQkJCQltYXhfcGZuX21hcHBlZCA9IHBmbjsKIAkJ
CQljb250aW51ZTsKIAkJCX0KIAkJCXB0ZSA9IG9uZV9wYWdlX3RhYmxlX2luaXQocG1kKTsKIAog
CQkJZm9yIChwdGVfb2ZzID0gMDsKLQkJCSAgICAgcHRlX29mcyA8IFBUUlNfUEVSX1BURSAmJiBw
Zm4gPCBtYXhfbG93X3BmbjsKKwkJCSAgICAgcHRlX29mcyA8IFBUUlNfUEVSX1BURSAmJiBwZm4g
PCBsaW1pdF9wZm47CiAJCQkgICAgIHB0ZSsrLCBwZm4rKywgcHRlX29mcysrLCBhZGRyICs9IFBB
R0VfU0laRSkgewogCQkJCXBncHJvdF90IHByb3QgPSBQQUdFX0tFUk5FTDsKIApAQCAtMjQ5LDcg
KzI0OSw2IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBrZXJuZWxfcGh5c2ljYWxfbWFwcGkKIAkJCQlw
YWdlc180aysrOwogCQkJCXNldF9wdGUocHRlLCBwZm5fcHRlKHBmbiwgcHJvdCkpOwogCQkJfQot
CQkJbWF4X3Bmbl9tYXBwZWQgPSBwZm47CiAJCX0KIAl9CiAJdXBkYXRlX3BhZ2VfY291bnQoUEdf
TEVWRUxfMk0sIHBhZ2VzXzJtKTsKQEAgLTcyOSw3ICs3MjgsNyBAQCB2b2lkIF9faW5pdCBzZXR1
cF9ib290bWVtX2FsbG9jYXRvcih2b2lkCiAKIHN0YXRpYyB2b2lkIF9faW5pdCBmaW5kX2Vhcmx5
X3RhYmxlX3NwYWNlKHVuc2lnbmVkIGxvbmcgZW5kKQogewotCXVuc2lnbmVkIGxvbmcgcHVkcywg
cG1kcywgdGFibGVzLCBzdGFydDsKKwl1bnNpZ25lZCBsb25nIHB1ZHMsIHBtZHMsIHB0ZXMsIHRh
Ymxlcywgc3RhcnQ7CiAKIAlwdWRzID0gKGVuZCArIFBVRF9TSVpFIC0gMSkgPj4gUFVEX1NISUZU
OwogCXRhYmxlcyA9IFBBR0VfQUxJR04ocHVkcyAqIHNpemVvZihwdWRfdCkpOwpAQCAtNzM3LDEw
ICs3MzYsMTUgQEAgc3RhdGljIHZvaWQgX19pbml0IGZpbmRfZWFybHlfdGFibGVfc3BhYwogCXBt
ZHMgPSAoZW5kICsgUE1EX1NJWkUgLSAxKSA+PiBQTURfU0hJRlQ7CiAJdGFibGVzICs9IFBBR0Vf
QUxJR04ocG1kcyAqIHNpemVvZihwbWRfdCkpOwogCi0JaWYgKCFjcHVfaGFzX3BzZSkgewotCQlp
bnQgcHRlcyA9IChlbmQgKyBQQUdFX1NJWkUgLSAxKSA+PiBQQUdFX1NISUZUOwotCQl0YWJsZXMg
Kz0gUEFHRV9BTElHTihwdGVzICogc2l6ZW9mKHB0ZV90KSk7Ci0JfQorCWlmIChjcHVfaGFzX3Bz
ZSkgeworCQl1bnNpZ25lZCBsb25nIGV4dHJhOworCQlleHRyYSA9IGVuZCAtICgoZW5kPj4yMSkg
PDwgMjEpOworCQlleHRyYSArPSAoMlVMPDwyMCk7CisJCXB0ZXMgPSAoZXh0cmEgKyBQQUdFX1NJ
WkUgLSAxKSA+PiBQQUdFX1NISUZUOworCX0gZWxzZQorCQlwdGVzID0gKGVuZCArIFBBR0VfU0la
RSAtIDEpID4+IFBBR0VfU0hJRlQ7CisKKwl0YWJsZXMgKz0gUEFHRV9BTElHTihwdGVzICogc2l6
ZW9mKHB0ZV90KSk7CiAKIAkvKgogCSAqIFJFRC1QRU4gcHV0dGluZyBwYWdlIHRhYmxlcyBvbmx5
IG9uIG5vZGUgMCBjb3VsZAo=
------=_Part_11060_24307440.1214649039657--
