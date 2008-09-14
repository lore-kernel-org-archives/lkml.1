Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYINFzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYINFzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 01:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYINFzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 01:55:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:17893 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYINFzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 01:55:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=WVEbl0ROTcGLjraMFYtT9aoTndyrnCvM4diEioDKzxoER5YRfGheV9naNl2wymVeKn
         Ei7GK/8akPC9MY0F9sDKctFz4lkmSsU/oAdI3afebSjL68XFP0fcrkinHgSt5Ug3kzRC
         W4V1mkdc1IRbXTRY+7ycPrz1wlTAAIRMClMCw=
Message-ID: <86802c440809132255sa518aa8g51136ae21a880e2d@mail.gmail.com>
Date: Sat, 13 Sep 2008 22:55:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Krzysztof Helt" <krzysztof.h1@wp.pl>
Subject: Re: [PATCH] x86: better CPU identification without the CPUID
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       mingo@redhat.com
In-Reply-To: <86802c440809132143p287edb82i6a73efbc53e6e93f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_41339_2844801.1221371710777"
References: <20080913125606.d655bdcf.krzysztof.h1@wp.pl>
	 <86802c440809132143p287edb82i6a73efbc53e6e93f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_41339_2844801.1221371710777
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Sep 13, 2008 at 9:43 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sat, Sep 13, 2008 at 3:56 AM, Krzysztof Helt <krzysztof.h1@wp.pl> wrote:
>> From: Krzysztof Helt <krzysztof.h1@wp.pl>
>>
>> cpus without the CPUID instruction are identified
>> as general 386 or 486 while some cpus (mostly made
>> by Cyrix) provide c_identify function which identify
>> correctly older cpus using cpu specific registers).
>>
>> Cyrix cpus are even worse as 5x86 and 6x68 have
>> the CPUID instruction disabled. The CPUID is
>> enabled by the c_identify() but the c_identify
>> is only called when the CPUID is available.
>>
>> Fix this by calling the c_identify() for all known
>> cpu families if there is no the CPUID instruction

I updated it to tip/master and call that in early_identify_cpu. it
should solve mtrr detection for Cyrix ...

Please check attached patch.

Thanks

YH

------=_Part_41339_2844801.1221371710777
Content-Type: text/x-patch; name=identify_cpu_without_cpuid.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fl394jmq0
Content-Disposition: attachment; filename=identify_cpu_without_cpuid.patch

W1BBVENIXSB4ODY6IGlkZW50aWZ5X2NwdV93aXRob3V0X2NwdWlkCgpuZWVkIHRvIGNhbGwgY19p
ZGVudGlmeSgpIGZvciBjcHVzIHdpdGhvdXQgY3B1aWQgZWFybGllci4uLgoKU2lnbmVkLW9mZi1i
eTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoKLS0tCiBhcmNoL3g4Ni9rZXJu
ZWwvY3B1L2NvbW1vbi5jIHwgICA2MyArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0t
LS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRpb25z
KC0pCgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYworKysg
bGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKQEAgLTQ4NSw2ICs0ODUsMzMg
QEAgc3RhdGljIHZvaWQgX19jcHVpbml0IGdldF9jcHVfY2FwKHN0cnVjdAogCQljLT54ODZfcG93
ZXIgPSBjcHVpZF9lZHgoMHg4MDAwMDAwNyk7CiAKIH0KKworc3RhdGljIHZvaWQgX19jcHVpbml0
IGlkZW50aWZ5X2NwdV93aXRob3V0X2NwdWlkKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykKK3sKKyNp
ZmRlZiBDT05GSUdfWDg2XzMyCisJaW50IGk7CisKKwkvKgorCSAqIEZpcnN0IG9mIGFsbCwgZGVj
aWRlIGlmIHRoaXMgaXMgYSA0ODYgb3IgaGlnaGVyCisJICogSXQncyBhIDQ4NiBpZiB3ZSBjYW4g
bW9kaWZ5IHRoZSBBQyBmbGFnCisJICovCisJaWYgKGZsYWdfaXNfY2hhbmdlYWJsZV9wKFg4Nl9F
RkxBR1NfQUMpKQorCQljLT54ODYgPSA0OworCWVsc2UKKwkJYy0+eDg2ID0gMzsKKworCWZvciAo
aSA9IDA7IGkgPCBYODZfVkVORE9SX05VTTsgaSsrKQorCQlpZiAoY3B1X2RldnNbaV0gJiYgY3B1
X2RldnNbaV0tPmNfaWRlbnRpZnkpIHsKKwkJCWMtPng4Nl92ZW5kb3JfaWRbMF0gPSAwOworCQkJ
Y3B1X2RldnNbaV0tPmNfaWRlbnRpZnkoYyk7CisJCQlpZiAoYy0+eDg2X3ZlbmRvcl9pZFswXSkg
eworCQkJCWdldF9jcHVfdmVuZG9yKGMpOworCQkJCWJyZWFrOworCQkJfQorCQl9CisjZW5kaWYK
K30KKwogLyoKICAqIERvIG1pbmltdW0gQ1BVIGRldGVjdGlvbiBlYXJseS4KICAqIEZpZWxkcyBy
ZWFsbHkgbmVlZGVkOiB2ZW5kb3IsIGNwdWlkX2xldmVsLCBmYW1pbHksIG1vZGVsLCBtYXNrLApA
QCAtNTAzLDE4ICs1MzAsMTcgQEAgc3RhdGljIHZvaWQgX19pbml0IGVhcmx5X2lkZW50aWZ5X2Nw
dShzdAogI2VuZGlmCiAJYy0+eDg2X2NhY2hlX2FsaWdubWVudCA9IGMtPng4Nl9jbGZsdXNoX3Np
emU7CiAKLQlpZiAoIWhhdmVfY3B1aWRfcCgpKQotCQlyZXR1cm47Ci0KIAltZW1zZXQoJmMtPng4
Nl9jYXBhYmlsaXR5LCAwLCBzaXplb2YgYy0+eDg2X2NhcGFiaWxpdHkpOwotCiAJYy0+ZXh0ZW5k
ZWRfY3B1aWRfbGV2ZWwgPSAwOwogCi0JY3B1X2RldGVjdChjKTsKLQotCWdldF9jcHVfdmVuZG9y
KGMpOwotCi0JZ2V0X2NwdV9jYXAoYyk7CisJaWYgKCFoYXZlX2NwdWlkX3AoKSkgeworCQlpZGVu
dGlmeV9jcHVfd2l0aG91dF9jcHVpZChjKTsKKwkJcmV0dXJuOworCX0gZWxzZSB7CisJCWNwdV9k
ZXRlY3QoYyk7CisJCWdldF9jcHVfdmVuZG9yKGMpOworCQlnZXRfY3B1X2NhcChjKTsKKwl9CiAK
IAlpZiAodGhpc19jcHUtPmNfZWFybHlfaW5pdCkKIAkJdGhpc19jcHUtPmNfZWFybHlfaW5pdChj
KTsKQEAgLTU4MywxMSArNjA5LDEzIEBAIHN0YXRpYyB2b2lkIF9fY3B1aW5pdCBkZXRlY3Rfbm9w
bChzdHJ1Y3QKIAogc3RhdGljIHZvaWQgX19jcHVpbml0IGdlbmVyaWNfaWRlbnRpZnkoc3RydWN0
IGNwdWluZm9feDg2ICpjKQogewotCWlmICghaGF2ZV9jcHVpZF9wKCkpCi0JCXJldHVybjsKLQog
CWMtPmV4dGVuZGVkX2NwdWlkX2xldmVsID0gMDsKIAorCWlmICghaGF2ZV9jcHVpZF9wKCkpIHsK
KwkJaWRlbnRpZnlfY3B1X3dpdGhvdXRfY3B1aWQoYyk7CisJCXJldHVybjsKKwl9CisKIAljcHVf
ZGV0ZWN0KGMpOwogCiAJZ2V0X2NwdV92ZW5kb3IoYyk7CkBAIC02MzksMTcgKzY2Nyw2IEBAIHN0
YXRpYyB2b2lkIF9fY3B1aW5pdCBpZGVudGlmeV9jcHUoc3RydWMKIAljLT54ODZfY2FjaGVfYWxp
Z25tZW50ID0gYy0+eDg2X2NsZmx1c2hfc2l6ZTsKIAltZW1zZXQoJmMtPng4Nl9jYXBhYmlsaXR5
LCAwLCBzaXplb2YgYy0+eDg2X2NhcGFiaWxpdHkpOwogCi0JaWYgKCFoYXZlX2NwdWlkX3AoKSkg
ewotCQkvKgotCQkgKiBGaXJzdCBvZiBhbGwsIGRlY2lkZSBpZiB0aGlzIGlzIGEgNDg2IG9yIGhp
Z2hlcgotCQkgKiBJdCdzIGEgNDg2IGlmIHdlIGNhbiBtb2RpZnkgdGhlIEFDIGZsYWcKLQkJICov
Ci0JCWlmIChmbGFnX2lzX2NoYW5nZWFibGVfcChYODZfRUZMQUdTX0FDKSkKLQkJCWMtPng4NiA9
IDQ7Ci0JCWVsc2UKLQkJCWMtPng4NiA9IDM7Ci0JfQotCiAJZ2VuZXJpY19pZGVudGlmeShjKTsK
IAogCWlmICh0aGlzX2NwdS0+Y19pZGVudGlmeSkK
------=_Part_41339_2844801.1221371710777--
