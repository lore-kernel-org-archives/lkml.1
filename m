Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYGIB4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYGIB4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 21:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYGIB4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 21:56:40 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:21138 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYGIB4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 21:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=KRZ7sOSHoJcb3mVpAGWDwWq6s/Ifodp2hDFoQfbfPxyFgfRRD926nlnysTgOAc/qvu
         A0tMB5cVj59kf0vdeYGHhrNElPiHa4OWU/QSqaxMMnyWIvoHv02lXHgkpTYiLHjKKSWs
         /QbOjoQEzyX39AoNOmU3wg/k1av5M2F5tqJFw=
Message-ID: <86802c440807081856y17eb1f1cs5647b2c2a765f429@mail.gmail.com>
Date: Tue, 8 Jul 2008 18:56:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke max_pfn_mapped
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_38466_8413854.1215568598703"
References: <20080708230837.GD1678@linux-os.sc.intel.com>
	 <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_38466_8413854.1215568598703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Jul 8, 2008 at 5:59 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Tue, Jul 8, 2008 at 4:08 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>> With out this 64bit tip/master doesn't boot using ACPI on my system.
>> ---
>>
>> max_pfn_mapped should include all e820 entries.
>> The direct mapping extends to max_pfn_mapped, so that we can directly access
>> apertures, ACPI and other tables without having to play with fixmaps.
>>
>> With this, my system with 1GB memory boots fine with ACPI enabled.
>
> so without this patch, your system doesn't boot?

how about attached patch?

[PATCH] x86: make max_pfn cover acpi table below 4g

when system have 4g less ram installed, and acpi table sit
near end of ram. make max_pfn cover them too.
so 64bit kernel don't need to mess up fixmap

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

YH

------=_Part_38466_8413854.1215568598703
Content-Type: text/x-patch; name=e820_end.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fifa2y1n0
Content-Disposition: attachment; filename=e820_end.patch

W1BBVENIXSB4ODY6IG1ha2UgbWF4X3BmbiBjb3ZlciBhY3BpIHRhYmxlIGJlbG93IDRnCgp3aGVu
IHN5c3RlbSBoYXZlIDRnIGxlc3MgcmFtIGluc3RhbGxlZCwgYW5kIGFjcGkgdGFibGUgc2l0Cm5l
YXIgZW5kIG9mIHJhbS4gbWFrZSBtYXhfcGZuIGNvdmVyIHRoZW0gdG9vLgpzbyA2NGJpdCBrZXJu
ZWwgZG9uJ3QgbmVlZCB0byBtZXNzIHVwIGZpeG1hcC4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkg
THUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCi0tLQogYXJjaC94ODYva2VybmVsL2U4MjAuYyAg
fCAgIDE4ICsrKysrKysrKysrKy0tLS0tLQogYXJjaC94ODYva2VybmVsL3NldHVwLmMgfCAgIDEz
ICsrKy0tLS0tLS0tLS0KIGluY2x1ZGUvYXNtLXg4Ni9lODIwLmggIHwgICAgMiArLQogMyBmaWxl
cyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51
eC0yLjYvYXJjaC94ODYva2VybmVsL2U4MjAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3Jp
Zy9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2U4
MjAuYwpAQCAtMTA1NiwxMiArMTA1NiwyMCBAQCB1bnNpZ25lZCBsb25nIF9faW5pdGRhdGEgZW5k
X3VzZXJfcGZuID0KIC8qCiAgKiBGaW5kIHRoZSBoaWdoZXN0IHBhZ2UgZnJhbWUgbnVtYmVyIHdl
IGhhdmUgYXZhaWxhYmxlCiAgKi8KLXVuc2lnbmVkIGxvbmcgX19pbml0IGU4MjBfZW5kX29mX3Jh
bSh2b2lkKQordW5zaWduZWQgbG9uZyBfX2luaXQgZTgyMF9lbmQodm9pZCkKIHsKLQl1bnNpZ25l
ZCBsb25nIGxhc3RfcGZuOworCWludCBpOworCXVuc2lnbmVkIGxvbmcgbGFzdF9wZm4gPSAwOwog
CXVuc2lnbmVkIGxvbmcgbWF4X2FyY2hfcGZuID0gTUFYX0FSQ0hfUEZOOwogCi0JbGFzdF9wZm4g
PSBmaW5kX21heF9wZm5fd2l0aF9hY3RpdmVfcmVnaW9ucygpOworCWZvciAoaSA9IDA7IGkgPCBl
ODIwLm5yX21hcDsgaSsrKSB7CisJCXN0cnVjdCBlODIwZW50cnkgKmVpID0gJmU4MjAubWFwW2ld
OworCQl1bnNpZ25lZCBsb25nIGVuZF9wZm47CisKKwkJZW5kX3BmbiA9IChlaS0+YWRkciArIGVp
LT5zaXplKSA+PiBQQUdFX1NISUZUOworCQlpZiAoZW5kX3BmbiA+IGxhc3RfcGZuKQorCQkJbGFz
dF9wZm4gPSBlbmRfcGZuOworCX0KIAogCWlmIChsYXN0X3BmbiA+IG1heF9hcmNoX3BmbikKIAkJ
bGFzdF9wZm4gPSBtYXhfYXJjaF9wZm47CkBAIC0xMTkyLDkgKzEyMDAsNyBAQCBzdGF0aWMgaW50
IF9faW5pdCBwYXJzZV9tZW1tYXBfb3B0KGNoYXIKIAkJICogdGhlIHJlYWwgbWVtIHNpemUgYmVm
b3JlIG9yaWdpbmFsIG1lbW9yeSBtYXAgaXMKIAkJICogcmVzZXQuCiAJCSAqLwotCQllODIwX3Jl
Z2lzdGVyX2FjdGl2ZV9yZWdpb25zKDAsIDAsIC0xVUwpOwotCQlzYXZlZF9tYXhfcGZuID0gZTgy
MF9lbmRfb2ZfcmFtKCk7Ci0JCXJlbW92ZV9hbGxfYWN0aXZlX3JhbmdlcygpOworCQlzYXZlZF9t
YXhfcGZuID0gZTgyMF9lbmQoKTsKICNlbmRpZgogCQllODIwLm5yX21hcCA9IDA7CiAJCXVzZXJk
ZWYgPSAxOwpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCisrKyBsaW51eC0y
LjYvYXJjaC94ODYva2VybmVsL3NldHVwLmMKQEAgLTcxNCwyMiArNzE0LDE4IEBAIHZvaWQgX19p
bml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAllYXJseV9nYXJ0X2lvbW11X2NoZWNr
KCk7CiAjZW5kaWYKIAotCWU4MjBfcmVnaXN0ZXJfYWN0aXZlX3JlZ2lvbnMoMCwgMCwgLTFVTCk7
CiAJLyoKIAkgKiBwYXJ0aWFsbHkgdXNlZCBwYWdlcyBhcmUgbm90IHVzYWJsZSAtIHRodXMKIAkg
KiB3ZSBhcmUgcm91bmRpbmcgdXB3YXJkczoKIAkgKi8KLQltYXhfcGZuID0gZTgyMF9lbmRfb2Zf
cmFtKCk7CisJbWF4X3BmbiA9IGU4MjBfZW5kKCk7CiAKIAkvKiBwcmVhbGxvY2F0ZSA0ayBmb3Ig
bXB0YWJsZSBtcGMgKi8KIAllYXJseV9yZXNlcnZlX2U4MjBfbXBjX25ldygpOwogCS8qIHVwZGF0
ZSBlODIwIGZvciBtZW1vcnkgbm90IGNvdmVyZWQgYnkgV0IgTVRSUnMgKi8KIAltdHJyX2JwX2lu
aXQoKTsKLQlpZiAobXRycl90cmltX3VuY2FjaGVkX21lbW9yeShtYXhfcGZuKSkgewotCQlyZW1v
dmVfYWxsX2FjdGl2ZV9yYW5nZXMoKTsKLQkJZTgyMF9yZWdpc3Rlcl9hY3RpdmVfcmVnaW9ucygw
LCAwLCAtMVVMKTsKLQkJbWF4X3BmbiA9IGU4MjBfZW5kX29mX3JhbSgpOwotCX0KKwlpZiAobXRy
cl90cmltX3VuY2FjaGVkX21lbW9yeShtYXhfcGZuKSkKKwkJbWF4X3BmbiA9IGU4MjBfZW5kKCk7
CiAKICNpZmRlZiBDT05GSUdfWDg2XzMyCiAJLyogbWF4X2xvd19wZm4gZ2V0IHVwZGF0ZWQgaGVy
ZSAqLwpAQCAtNzcyLDkgKzc2OCw2IEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNt
ZGxpbmVfcCkKIAkgKi8KIAlhY3BpX2Jvb3RfdGFibGVfaW5pdCgpOwogCi0JLyogUmVtb3ZlIGFj
dGl2ZSByYW5nZXMgc28gcmVkaXNjb3Zlcnkgd2l0aCBOVU1BLWF3YXJlbmVzcyBoYXBwZW5zICov
Ci0JcmVtb3ZlX2FsbF9hY3RpdmVfcmFuZ2VzKCk7Ci0KICNpZmRlZiBDT05GSUdfQUNQSV9OVU1B
CiAJLyoKIAkgKiBQYXJzZSBTUkFUIHRvIGRpc2NvdmVyIG5vZGVzLgpJbmRleDogbGludXgtMi42
L2luY2x1ZGUvYXNtLXg4Ni9lODIwLmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvaW5j
bHVkZS9hc20teDg2L2U4MjAuaAorKysgbGludXgtMi42L2luY2x1ZGUvYXNtLXg4Ni9lODIwLmgK
QEAgLTk5LDcgKzk5LDcgQEAgZXh0ZXJuIHZvaWQgZnJlZV9lYXJseSh1NjQgc3RhcnQsIHU2NCBl
bgogZXh0ZXJuIHZvaWQgZWFybHlfcmVzX3RvX2Jvb3RtZW0odTY0IHN0YXJ0LCB1NjQgZW5kKTsK
IGV4dGVybiB1NjQgZWFybHlfcmVzZXJ2ZV9lODIwKHU2NCBzdGFydHQsIHU2NCBzaXpldCwgdTY0
IGFsaWduKTsKIAotZXh0ZXJuIHVuc2lnbmVkIGxvbmcgZTgyMF9lbmRfb2ZfcmFtKHZvaWQpOwor
ZXh0ZXJuIHVuc2lnbmVkIGxvbmcgZTgyMF9lbmQodm9pZCk7CiBleHRlcm4gaW50IGU4MjBfZmlu
ZF9hY3RpdmVfcmVnaW9uKGNvbnN0IHN0cnVjdCBlODIwZW50cnkgKmVpLAogCQkJCSAgdW5zaWdu
ZWQgbG9uZyBzdGFydF9wZm4sCiAJCQkJICB1bnNpZ25lZCBsb25nIGxhc3RfcGZuLAo=
------=_Part_38466_8413854.1215568598703--
